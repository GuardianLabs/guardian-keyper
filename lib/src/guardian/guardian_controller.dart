import 'dart:typed_data';
import 'package:collection/collection.dart' show IterableEquality;
import 'package:flutter/material.dart' hide Router;
import 'package:p2plib/p2plib.dart';

import '../core/utils.dart';
import '../core/service/event_bus.dart';
import '../core/model/p2p_model.dart' hide PubKey;
import 'guardian_model.dart';
import 'guardian_service.dart';

enum ProcessingStatus { notInited, inited, waiting, finished, error }

class GuardianController extends TopicHandler with ChangeNotifier {
  static const _topicOfThis = 101;
  static const _topicSubscribeTo = 100;

  GuardianController({
    required GuardianService guardianService,
    required EventBus eventBus,
    required Router router,
  })  : _guardianService = guardianService,
        super(router) {
    eventBus.on<RecoveryGroupClearCommand>().listen((event) => clearStorage());
  }

  final GuardianService _guardianService;
  Set<SecretShard> _secretShards = {};
  Set<PubKey> _trustedPeers = {};
  AuthToken? _currentAuthToken;
  ProcessingStatus _processStatus = ProcessingStatus.notInited;

  ProcessingStatus get processStatus => _processStatus;

  @override
  void onStarted() {}

  @override
  Uint64List topics() => Uint64List.fromList([_topicSubscribeTo]);

  @override
  void onMessage(Uint8List data, Peer peer) async {
    final p2pPacket = P2PPacket.fromCbor(data);
    final peerPubKey = p2pPacket.header.srcKey;

    switch (p2pPacket.type) {
      case MessageType.authPeer:
        if (_currentAuthToken == AuthToken(p2pPacket.body)) {
          _trustedPeers.add(peerPubKey);
          await _guardianService
              .setTrustedPeers(_trustedPeers.map((e) => e.data).toSet());
          _processStatus = ProcessingStatus.waiting;
        } else {
          _processStatus = ProcessingStatus.error;
        }
        _currentAuthToken = null;
        router.send(
            peerPubKey,
            P2PPacket.emptyBody(
              header: Header(_topicOfThis, router.pubKey, peerPubKey),
              type: MessageType.authPeer,
              status: _processStatus == ProcessingStatus.waiting
                  ? MessageStatus.success
                  : MessageStatus.reject,
            ).toCbor());
        notifyListeners();
        break;

      case MessageType.setShard:
        if (_trustedPeers.contains(peerPubKey)) {
          final secretShard = SetShardPacket.fromCbor(p2pPacket.body);
          _secretShards.add(SecretShard(
            owner: peerPubKey.data,
            secret: secretShard.secretShard,
            groupId: secretShard.groupId,
          ));
          await _guardianService.setSecretShards(_secretShards);
          _processStatus = ProcessingStatus.finished;
        } else {
          _processStatus = ProcessingStatus.error;
        }
        router.send(
            peerPubKey,
            P2PPacket.emptyBody(
              header: Header(_topicOfThis, router.pubKey, peerPubKey),
              type: MessageType.setShard,
              status: _processStatus == ProcessingStatus.finished
                  ? MessageStatus.success
                  : MessageStatus.reject,
            ).toCbor());
        notifyListeners();
        break;

      case MessageType.getShard:
        final secretShard = _secretShards.firstWhere(
          (e) =>
              PubKey(e.owner) == peerPubKey &&
              const IterableEquality().equals(e.groupId, p2pPacket.body),
          orElse: () => SecretShard.empty(),
        );
        router.send(
            peerPubKey,
            P2PPacket(
              header: Header(_topicOfThis, router.pubKey, peerPubKey),
              type: MessageType.getShard,
              status: secretShard.secret.isNotEmpty
                  ? MessageStatus.success
                  : MessageStatus.reject,
              body: secretShard.secret,
            ).toCbor());
        break;
      default:
    }
  }

  Future<void> load() async {
    _secretShards = await _guardianService.getSecretShards();
    _trustedPeers = (await _guardianService.getTrustedPeers())
        .map((e) => PubKey(e))
        .toSet();
  }

  Future<void> clearStorage() async {
    await _guardianService.clearSecretShards();
    _secretShards.clear();
    notifyListeners();
  }

  void generateAuthToken() {
    _currentAuthToken = AuthToken(getRandomBytes(AuthToken.length));
    _processStatus = ProcessingStatus.inited;
    // notifyListeners();
  }

  QRCode getQRCode(Uint8List myPubKey, [Uint8List? mySignPubKey]) => QRCode(
        header: Uint8List(4),
        authToken: _currentAuthToken!.data,
        pubKey: myPubKey,
        signPubKey: mySignPubKey ?? myPubKey,
      );
}
