import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/widgets.dart' hide Router;
import 'package:ntcdcrypto/ntcdcrypto.dart';
import 'package:p2plib/p2plib.dart';

import '/src/core/service/event_bus.dart';
import '/src/core/model/p2p_model.dart';
import '/src/core/utils.dart';
import 'recovery_group_model.dart';
import 'recovery_group_service.dart';

class RecoveryGroupController extends TopicHandler with ChangeNotifier {
  static const _topicOfOwner = 100;
  static const _topicOfGuardian = 101;

  final p2pNetwork = StreamController<P2PPacket>.broadcast();
  final RecoveryGroupService _recoveryGroupService;

  Map<String, RecoveryGroupModel> _groups = {};
  String _deviceName = 'Undefined';
  InternetAddress? _deviceAddress;

  RecoveryGroupController({
    required RecoveryGroupService recoveryGroupService,
    required EventBus eventBus,
    required Router router,
  })  : _recoveryGroupService = recoveryGroupService,
        super(router) {
    eventBus.on<RecoveryGroupClearCommand>().listen((event) => clear());
    eventBus.on<SettingsChangedEvent>().listen((event) {
      _deviceName = event.deviceName;
      notifyListeners();
    });
  }

  Map<String, RecoveryGroupModel> get groups => _groups;

  @override
  Uint64List topics() => Uint64List.fromList([_topicOfGuardian]);

  @override
  void onMessage(Uint8List data, Peer peer) {
    final header = Header.deserialize(data.sublist(0, Header.length));
    if (header.dstKey != router.pubKey) return;
    router.addPeer(header.srcKey, peer);
    final p2pPacket = P2PPacket.fromCbor(
        P2PCrypto.decrypt(
          header.srcKey,
          router.keyPair.secretKey,
          data.sublist(Header.length),
        ),
        header.srcKey);

    if (p2pPacket.type == MessageType.takeOwnership &&
        p2pPacket.status == MessageStatus.request) {
      _processTakeOwnershipRequest(p2pPacket, header.srcKey);
    }
    p2pNetwork.add(p2pPacket);
  }

  //TBD: throw away this piece of shit, some day...
  void _processTakeOwnershipRequest(
    P2PPacket p2pPacket,
    PubKey peerPubKey,
  ) async {
    final secretShard = SecretShardPacket.fromCbor(p2pPacket.body);
    final group = _groups[secretShard.groupName];
    final guardian = RecoveryGroupGuardianModel(
      name: secretShard.ownerName,
      pubKey: peerPubKey,
      signPubKey: peerPubKey,
    );
    var status = MessageStatus.success;

    if (group == null) {
      final secret = RecoveryGroupSecretModel(name: secretShard.groupName);
      _groups[secretShard.groupName] = RecoveryGroupModel(
        id: GroupID(secretShard.groupId),
        name: secretShard.groupName,
        type: RecoveryGroupType.devices,
        isRestoring: true,
        fixedSize: secretShard.groupSize,
        guardians: {guardian.name: guardian},
        secrets: {secret.name: secret},
      );
      await _save();
    } else {
      if (group.isRestoring) {
        _groups[group.name] = group.addGuardian(guardian);
        await _save();
      } else {
        p2pNetwork.addError(RecoveryGroupAlreadyExists());
        status = MessageStatus.reject;
      }
    }
    await router
        .sendTo(
          _topicOfGuardian,
          peerPubKey,
          P2PPacket(
            type: MessageType.takeOwnership,
            status: status,
            body: secretShard.groupId,
          ).toCbor(),
          true,
        )
        .onError(p2pNetwork.addError);
  }

  Future<void> sendAuthRequest(QRCode guardianQRCode) async {
    final peerPubKey = PubKey(guardianQRCode.pubKey);
    if (guardianQRCode.address.isNotEmpty) {
      router.addPeer(peerPubKey,
          Peer(InternetAddress.fromRawAddress(guardianQRCode.address), 7342));
    }
    await router
        .sendTo(
          _topicOfOwner,
          peerPubKey,
          P2PPacket(
            type: MessageType.authPeer,
            body: guardianQRCode.authToken,
          ).toCbor(),
          true,
        )
        .onError(p2pNetwork.addError);
  }

  Future<void> distributeShards(
    Map<PubKey, String> shards,
    String groupName,
    String secret,
  ) async {
    final recoveryGroup = _groups[groupName]!;
    for (var shard in shards.entries) {
      await router
          .sendTo(
            _topicOfOwner,
            shard.key,
            P2PPacket(
              type: MessageType.setShard,
              body: SecretShardPacket(
                ownerName: _deviceName,
                groupName: groupName,
                groupSize: recoveryGroup.size,
                groupThreshold: recoveryGroup.threshold,
                groupId: recoveryGroup.id.data,
                secretShard: Uint8List.fromList(shard.value.codeUnits),
              ).toCbor(),
            ).toCbor(),
            true,
          )
          .onError(p2pNetwork.addError);
    }
  }

  Future<void> requestShards(
    String groupName, [
    Set<PubKey> excludePeers = const {},
  ]) async {
    final recoveryGroup = _groups[groupName]!;
    final peers = recoveryGroup.guardians.values
        .map((e) => e.pubKey)
        .toSet()
        .difference(excludePeers);

    for (var peer in peers) {
      await router
          .sendTo(
            _topicOfOwner,
            peer,
            P2PPacket(
              type: MessageType.getShard,
              body: recoveryGroup.id.data,
            ).toCbor(),
            true,
          )
          .onError(p2pNetwork.addError);
    }
  }

  Future<void> takeOwnershipRequest(QRCode guardianQRCode) async {
    final peerPubKey = PubKey(guardianQRCode.pubKey);
    if (guardianQRCode.address.isNotEmpty) {
      router.addPeer(peerPubKey,
          Peer(InternetAddress.fromRawAddress(guardianQRCode.address), 7342));
    }
    await router
        .sendTo(
          _topicOfOwner,
          peerPubKey,
          P2PPacket(
            type: MessageType.takeOwnership,
            body: guardianQRCode.authToken,
          ).toCbor(),
          true,
        )
        .onError(p2pNetwork.addError);
  }

  Map<PubKey, String> splitSecret(String secret, RecoveryGroupModel group) {
    final shards =
        SSS().create(group.threshold, group.guardians.length, secret, true);
    final guardians = group.guardians.values.toList();
    return {
      for (var i = 0; i < shards.length; i++) guardians[i].pubKey: shards[i]
    };
  }

  String restoreSecret(List<String> shards) => SSS().combine(shards, true);

  QRCode getQRCode() => QRCode(
        authToken: RawToken(len: 32, data: getRandomBytes(32)).data,
        pubKey: router.pubKey.data,
        signPubKey: router.pubKey.data,
        type: MessageType.takeOwnership,
        peerName: _deviceName,
        address:
            _deviceAddress == null ? Uint8List(0) : _deviceAddress!.rawAddress,
      );

  Future<void> load([String? deviceName, String? deviceAddress]) async {
    if (deviceName != null) _deviceName = deviceName;
    if (deviceAddress != null) {
      _deviceAddress = InternetAddress.tryParse(deviceAddress);
    }
    try {
      _groups = await _recoveryGroupService.getGroups();
    } catch (_) {}
  }

  Future<void> _save() async {
    await _recoveryGroupService.setGroups(_groups);
    notifyListeners();
  }

  Future<void> clear() async {
    await _recoveryGroupService.clearGroups();
    _groups.clear();
    notifyListeners();
  }

  Future<void> addGroup(RecoveryGroupModel group) async {
    if (_groups.containsKey(group.name)) throw RecoveryGroupAlreadyExists();
    _groups[group.name] = group;
    await _save();
  }

  Future<void> removeGroup(String groupName) async {
    _groups.remove(groupName);
    await _save();
  }

  Future<void> addGuardian(
    String groupName,
    RecoveryGroupGuardianModel guardian,
  ) async {
    if (!_groups.containsKey(groupName)) throw RecoveryGroupDoesNotExist();
    final group = _groups[groupName]!;
    _groups[groupName] = group.addGuardian(guardian);
    await _save();
  }

  Future<void> addSecret(
    String groupName,
    RecoveryGroupSecretModel secret,
  ) async {
    final group = _groups[groupName]!;
    final updatedGroup = group.addSecret(secret);
    _groups[groupName] = updatedGroup;
    await _save();
  }
}

class RecoveryGroupAlreadyExists implements Exception {
  static const description = 'Group with given name already exists!';
}

class RecoveryGroupIsFull implements Exception {
  static const description = 'Group with given name is full!';
}

class RecoveryGroupDoesNotExist implements Exception {
  static const description = 'Group with given name does not exist!';
}
