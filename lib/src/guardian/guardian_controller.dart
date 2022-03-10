import 'dart:typed_data';
import 'package:flutter/material.dart' hide Router;
import 'package:p2plib/p2plib.dart';

import '../core/utils.dart';
import '../core/service/event_bus.dart';
import '../core/model/qr_code_model.dart';
import '../core/model/p2p_model.dart' hide PubKey;
import '../core/model/owner_packet.dart';
import '../core/model/keeper_packet.dart';
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
    eventBus.on<RecoveryGroupClearCommand>().listen((event) => clear());
  }

  final GuardianService _guardianService;
  Set<SecretShard> _secretShards = {};
  Set<PubKey> _trustedPeers = {};
  PubKey? _currentAuthToken;
  ProcessingStatus _processStatus = ProcessingStatus.notInited;

  ProcessingStatus get processStatus => _processStatus;

  @override
  void onStarted() {}

  @override
  Uint64List topics() => Uint64List.fromList([_topicSubscribeTo]);

  @override
  void onMessage(Uint8List data, Peer peer) async {
    final packet = OwnerPacket.deserialize(data);
    final peerPubKey = packet.header.srcKey;
    final body = OwnerBody.deserialize(
        P2PCrypto.decrypt(peerPubKey, router.keyPair.secretKey, packet.body));

    switch (body.type) {
      case OwnerMsgType.authPeer:
        if (_currentAuthToken == PubKey(body.data)) {
          _trustedPeers.add(peerPubKey);
          await _guardianService
              .setTrustedPeers(_trustedPeers.map((e) => e.data).toSet());
          _processStatus = ProcessingStatus.waiting;
          _sendResponse(
              peerPubKey, KeeperBody.createAuthStatus(ProcessStatus.success));
        } else {
          _processStatus = ProcessingStatus.error;
          _sendResponse(
              peerPubKey, KeeperBody.createAuthStatus(ProcessStatus.reject));
        }
        _currentAuthToken = null;
        notifyListeners();
        break;

      case OwnerMsgType.setShard:
        if (_trustedPeers.contains(peerPubKey)) {
          try {
            await _guardianService.setSecretShards(_secretShards);
            //TBD groupId
            _secretShards.add(SecretShard(
                owner: peerPubKey.data, secret: body.data, groupId: ''));
            _processStatus = ProcessingStatus.finished;
          } on Exception {
            _processStatus = ProcessingStatus.error;
          } finally {
            notifyListeners();
          }
        } else {
          _processStatus = ProcessingStatus.error;
          _sendResponse(peerPubKey,
              KeeperBody.createSaveDataStatus(ProcessStatus.reject));
          notifyListeners();
        }
        break;

      case OwnerMsgType.getShard:
        late final Uint8List shard;
        try {
          //TBD groupId
          shard = _secretShards
              .firstWhere(
                  (e) => PubKey(e.owner) == peerPubKey && e.groupId == '')
              .secret;
        } on StateError {
          shard = Uint8List(0);
        } finally {
          _sendResponse(
              peerPubKey, KeeperBody(KeeperMsgType.getShardResult, shard));
        }
        break;
    }
  }

  void _sendResponse(PubKey peerPubKey, KeeperBody body) => router.send(
      peerPubKey,
      KeeperPacket(
        Header(_topicOfThis, router.pubKey, peerPubKey),
        P2PCrypto.encrypt(
            peerPubKey, router.keyPair.secretKey, body.serialize()),
      ).serialize());

  Future<void> load() async {
    _secretShards = await _guardianService.getSecretShards();
    _trustedPeers = (await _guardianService.getTrustedPeers())
        .map((e) => PubKey(e))
        .toSet();
  }

  Future<void> clear() async {
    await _guardianService.clearSecretShards();
    _secretShards.clear();
    notifyListeners();
  }

  void reset() {
    _currentAuthToken = null;
    _processStatus = ProcessingStatus.notInited;
    notifyListeners();
  }

  void generateAuthToken() {
    _currentAuthToken = PubKey(getRandomBytes(PubKey.length));
    _processStatus = ProcessingStatus.inited;
    notifyListeners();
  }

  QRCodeModel getQRCode(Uint8List myPubKey, [Uint8List? mySignPubKey]) =>
      QRCodeModel(
        header: Uint8List.fromList([0, 0, 0, 0]),
        authToken: _currentAuthToken!.data,
        pubKey: myPubKey,
        signPubKey: mySignPubKey ?? myPubKey,
      );
}
