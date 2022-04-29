import 'dart:io';
import 'dart:async';
import 'dart:typed_data';
import 'package:collection/collection.dart' show IterableEquality;
import 'package:flutter/material.dart' hide Router;
import 'package:p2plib/p2plib.dart';

import '/src/core/utils.dart';
import '/src/core/service/event_bus.dart';
import '/src/core/model/p2p_model.dart';

import 'guardian_model.dart';
import 'guardian_service.dart';

class GuardianController extends TopicHandler
    with ChangeNotifier, WidgetsBindingObserver {
  static const _topicOfGuardian = 101;
  static const _topicOfOwner = 100;

  final p2pNetwork = StreamController<P2PPacket>.broadcast();
  final GuardianService _guardianService;

  String _deviceName = 'Undefined';
  InternetAddress? _deviceAddress;
  Set<SecretShard> secretShards = {};
  Set<PubKey> _trustedPeers = {};
  RawToken _currentAuthToken = RawToken(len: 32, data: getRandomBytes(32));

  GuardianController({
    required GuardianService guardianService,
    required EventBus eventBus,
    required Router router,
  })  : _guardianService = guardianService,
        super(router) {
    WidgetsBinding.instance!.addObserver(this);
    eventBus.on<RecoveryGroupClearCommand>().listen((_) => clearStorage());
    eventBus.on<SettingsChangedEvent>().listen((event) {
      _deviceName = event.deviceName;
      notifyListeners();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.paused) {
      router.connection.closeConnection();
    } else if (state == AppLifecycleState.resumed) {
      await router.connection.openConnection();
      await router.connection.startListen();
    }
  }

  @override
  Uint64List topics() => Uint64List.fromList([_topicOfOwner]);

  @override
  void onMessage(Uint8List data, Peer peer) async {
    final header = Header.deserialize(data.sublist(0, Header.length));
    if (header.dstKey != router.pubKey) return;
    router.addPeer(header.srcKey, peer);
    final peerPubKey = header.srcKey;
    final p2pPacket = P2PPacket.fromCbor(P2PCrypto.decrypt(
      header.srcKey,
      router.keyPair.secretKey,
      data.sublist(Header.length),
    ));
    MessageStatus status = MessageStatus.reject;

    switch (p2pPacket.type) {
      case MessageType.authPeer:
        if (const IterableEquality()
            .equals(_currentAuthToken.data, p2pPacket.body)) {
          _trustedPeers.add(peerPubKey);
          await _guardianService
              .setTrustedPeers(_trustedPeers.map((e) => e.data).toSet());
          status = MessageStatus.success;
        }
        await router
            .sendTo(
                _topicOfGuardian,
                peerPubKey,
                P2PPacket(
                  type: MessageType.authPeer,
                  status: status,
                  body: Uint8List.fromList(_deviceName.codeUnits),
                ).toCbor(),
                true)
            .whenComplete(() {
          // TBD: security leak, use transaction
          if (status == MessageStatus.success) generateAuthToken();
        }).onError(p2pNetwork.addError);
        break;

      case MessageType.setShard:
        if (_trustedPeers.contains(peerPubKey)) {
          final secretShard = SecretShardPacket.fromCbor(p2pPacket.body);
          secretShards.add(SecretShard(
            owner: peerPubKey.data,
            value: secretShard.secretShard,
            groupId: secretShard.groupId,
            groupSize: secretShard.groupSize,
            groupThreshold: secretShard.groupThreshold,
            groupName: secretShard.groupName,
            ownerName: secretShard.ownerName,
          ));
          await _guardianService.setSecretShards(secretShards);
          status = MessageStatus.success;
          notifyListeners();
        }
        await router
            .sendTo(
                _topicOfGuardian,
                peerPubKey,
                P2PPacket.emptyBody(
                  type: MessageType.setShard,
                  status: status,
                ).toCbor(),
                true)
            .onError(p2pNetwork.addError);
        break;

      case MessageType.getShard:
        final secretShard = secretShards.firstWhere(
            (e) =>
                PubKey(e.owner) == peerPubKey &&
                const IterableEquality().equals(e.groupId, p2pPacket.body),
            orElse: () => SecretShard.empty());
        if (secretShard.value.isNotEmpty) status = MessageStatus.success;
        await router
            .sendTo(
                _topicOfGuardian,
                peerPubKey,
                P2PPacket(
                  type: MessageType.getShard,
                  status: status,
                  body: secretShard.value,
                ).toCbor(),
                true)
            .onError(p2pNetwork.addError);
        break;

      case MessageType.takeOwnership:
        p2pNetwork.add(p2pPacket);
        break;

      default:
    }
  }

  Future<void> sendTakeOwnershipRequest(
    QRCode guardianQRCode,
    SecretShard secretShard,
  ) async {
    final peerPubKey = PubKey(guardianQRCode.pubKey);
    if (guardianQRCode.address.isNotEmpty) {
      router.addPeer(peerPubKey,
          Peer(InternetAddress.fromRawAddress(guardianQRCode.address), 7342));
    }
    await router
        .sendTo(
          _topicOfGuardian,
          peerPubKey,
          P2PPacket(
            type: MessageType.takeOwnership,
            body: SecretShardPacket(
              groupId: secretShard.groupId,
              groupName: secretShard.groupName,
              ownerName: secretShard.ownerName,
              groupSize: secretShard.groupSize,
              groupThreshold: secretShard.groupThreshold,
              secretShard: Uint8List(0),
            ).toCbor(),
          ).toCbor(),
          true,
        )
        .onError(p2pNetwork.addError);
  }

  Future<void> removeShard(SecretShard secretShard) async {
    secretShards.remove(secretShard);
    await _guardianService.setSecretShards(secretShards);
    notifyListeners();
  }

  Future<void> changeOwnership(
    SecretShard secretShard,
    Uint8List peerPubKey,
    String ownerName,
  ) async {
    final updatedSecretShard = SecretShard(
      owner: peerPubKey,
      ownerName: ownerName,
      groupId: secretShard.groupId,
      groupName: secretShard.groupName,
      groupSize: secretShard.groupSize,
      groupThreshold: secretShard.groupThreshold,
      value: secretShard.value,
    );
    secretShards.removeWhere((e) =>
        const IterableEquality().equals(e.groupId, secretShard.groupId) &&
        const IterableEquality().equals(e.owner, secretShard.owner));
    secretShards.add(updatedSecretShard);
    await _guardianService.setSecretShards(secretShards);
    notifyListeners();
  }

  Future<void> load([String? deviceName, String? deviceAddress]) async {
    if (deviceName != null) _deviceName = deviceName;
    if (deviceAddress != null) {
      _deviceAddress = InternetAddress.tryParse(deviceAddress);
    }
    try {
      secretShards = await _guardianService.getSecretShards();
    } catch (_) {}
    try {
      _trustedPeers = (await _guardianService.getTrustedPeers())
          .map((e) => PubKey(e))
          .toSet();
    } catch (_) {}
    generateAuthToken();
  }

  Future<void> clearStorage() async {
    await _guardianService.clearSecretShards();
    secretShards.clear();
    notifyListeners();
  }

  void generateAuthToken() {
    _currentAuthToken = RawToken(len: 32, data: getRandomBytes(32));
    p2pNetwork.add(P2PPacket.emptyBody());
    notifyListeners();
  }

  QRCode getQRCode([Uint8List? myPubKey, Uint8List? mySignPubKey]) => QRCode(
        authToken: _currentAuthToken.data,
        pubKey: myPubKey ?? router.keyPair.publicKey,
        signPubKey: mySignPubKey ?? myPubKey ?? router.keyPair.publicKey,
        type: MessageType.authPeer,
        peerName: _deviceName,
        address:
            _deviceAddress == null ? Uint8List(0) : _deviceAddress!.rawAddress,
      );
}
