import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:collection/collection.dart' show IterableEquality;
import 'package:flutter/material.dart' hide Router;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:p2plib/p2plib.dart';

import '../core/utils.dart';
import '../core/service/event_bus.dart';
import '../core/model/p2p_model.dart' hide PubKey;
import 'guardian_model.dart';
import 'guardian_service.dart';

class GuardianController extends TopicHandler with ChangeNotifier {
  static const _topicOfThis = 101;
  static const _topicSubscribeTo = 100;
  static const _networkTimeout = Duration(seconds: 10);

  GuardianController({
    required GuardianService guardianService,
    required EventBus eventBus,
    required Router router,
  })  : _guardianService = guardianService,
        super(router) {
    eventBus.on<RecoveryGroupClearCommand>().listen((event) => clearStorage());
  }

  final networkStream = StreamController<P2PPacketStream>.broadcast();
  final GuardianService _guardianService;
  late final String deviceName;
  Set<SecretShard> _secretShards = {};
  Set<PubKey> _trustedPeers = {};
  AuthToken? _currentAuthToken;

  @override
  Uint64List topics() => Uint64List.fromList([_topicSubscribeTo]);

  @override
  void onMessage(Uint8List data, Peer peer) async {
    final header = Header.deserialize(data.sublist(0, Header.length - 1));
    final peerPubKey = header.srcKey;
    final p2pPacket =
        P2PPacket.fromCbor(data.sublist(Header.length), peerPubKey);
    networkStream
        .add(const P2PPacketStream(requestStatus: RequestStatus.recieved));

    switch (p2pPacket.type) {
      case MessageType.authPeer:
        if (_currentAuthToken != AuthToken(p2pPacket.body)) return;
        _trustedPeers.add(peerPubKey);
        await _guardianService
            .setTrustedPeers(_trustedPeers.map((e) => e.data).toSet());
        networkStream
            .add(const P2PPacketStream(requestStatus: RequestStatus.sending));
        await router
            .sendTo(
                _topicOfThis,
                peerPubKey,
                P2PPacket(
                  type: MessageType.authPeer,
                  status: MessageStatus.success,
                  body: Uint8List.fromList(deviceName.codeUnits),
                ).toCbor())
            .timeout(_networkTimeout,
                onTimeout: () => networkStream.add(const P2PPacketStream(
                    requestStatus: RequestStatus.timeout)))
            .whenComplete(() => generateAuthToken())
            .onError((e, s) => networkStream.add(P2PPacketStream(
                  requestStatus: RequestStatus.error,
                  error: e,
                  stackTrace: s,
                )));
        break;

      case MessageType.setShard:
        RequestStatus processStatus = RequestStatus.idle;
        if (_trustedPeers.contains(peerPubKey)) {
          final secretShard = SetShardPacket.fromCbor(p2pPacket.body);
          _secretShards.add(SecretShard(
            owner: peerPubKey.data,
            secret: secretShard.secretShard,
            groupId: secretShard.groupId,
          ));
          await _guardianService.setSecretShards(_secretShards);
          processStatus = RequestStatus.sending;
        } else {
          processStatus = RequestStatus.error;
        }
        networkStream.add(P2PPacketStream(requestStatus: processStatus));
        await router
            .sendTo(
                _topicOfThis,
                peerPubKey,
                P2PPacket.emptyBody(
                  type: MessageType.setShard,
                  status: processStatus == RequestStatus.sending
                      ? MessageStatus.success
                      : MessageStatus.reject,
                ).toCbor())
            .timeout(_networkTimeout,
                onTimeout: () => networkStream.add(const P2PPacketStream(
                    requestStatus: RequestStatus.timeout)))
            .onError((e, s) => networkStream.add(P2PPacketStream(
                  requestStatus: RequestStatus.error,
                  error: e,
                  stackTrace: s,
                )));
        break;

      case MessageType.getShard:
        final secretShard = _secretShards.firstWhere(
            (e) =>
                PubKey(e.owner) == peerPubKey &&
                const IterableEquality().equals(e.groupId, p2pPacket.body),
            orElse: () => SecretShard.empty());
        await router
            .sendTo(
                _topicOfThis,
                peerPubKey,
                P2PPacket(
                  type: MessageType.getShard,
                  status: secretShard.secret.isNotEmpty
                      ? MessageStatus.success
                      : MessageStatus.reject,
                  body: secretShard.secret,
                ).toCbor())
            .timeout(_networkTimeout,
                onTimeout: () => networkStream.add(const P2PPacketStream(
                    requestStatus: RequestStatus.timeout)))
            .onError((e, s) => networkStream.add(P2PPacketStream(
                  requestStatus: RequestStatus.error,
                  error: e,
                  stackTrace: s,
                )));
        break;

      default:
    }
  }

  Future<void> load() async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfoPlugin.androidInfo;
      deviceName = androidInfo.model ?? androidInfo.id ?? 'Undefined';
    }
    if (Platform.isIOS) {
      final iosInfo = await deviceInfoPlugin.iosInfo;
      deviceName = iosInfo.model ?? iosInfo.name ?? 'Undefined';
    }
    _secretShards = await _guardianService.getSecretShards();
    _trustedPeers = (await _guardianService.getTrustedPeers())
        .map((e) => PubKey(e))
        .toSet();
    generateAuthToken();
  }

  Future<void> clearStorage() async {
    await _guardianService.clearSecretShards();
    _secretShards.clear();
    notifyListeners();
  }

  void generateAuthToken() {
    _currentAuthToken = AuthToken(getRandomBytes(AuthToken.length));
    networkStream.add(const P2PPacketStream(requestStatus: RequestStatus.idle));
    notifyListeners();
  }

  QRCode getQRCode(Uint8List myPubKey, [Uint8List? mySignPubKey]) => QRCode(
        authToken: _currentAuthToken!.data,
        pubKey: myPubKey,
        signPubKey: mySignPubKey ?? myPubKey,
      );
}
