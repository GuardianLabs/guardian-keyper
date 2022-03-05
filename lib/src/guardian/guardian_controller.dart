import 'dart:typed_data';
import 'package:flutter/material.dart' hide Router;
import 'package:p2plib/p2plib.dart';

import '../core/utils.dart';
import '../core/service/event_bus.dart';
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
  Set<SecretShard> _managedShards = {};
  PubKey? _currentAuthToken;
  PubKey? _currentOwner;
  ProcessingStatus _processStatus = ProcessingStatus.notInited;

  ProcessingStatus get processStatus => _processStatus;

  @override
  void onStarted() {}

  @override
  Uint64List topics() => Uint64List.fromList([_topicSubscribeTo]);

  @override
  void onMessage(Uint8List data, Peer peer) async {
    final packet = OwnerPacket.deserialize(data);
    final owner = packet.header.srcKey;
    final body = OwnerBody.deserialize(
        P2PCrypto.decrypt(owner, router.keyPair.secretKey, packet.body));

    switch (body.type) {
      case OwnerMsgType.authPeer:
        if (_currentAuthToken == PubKey(body.data)) {
          _currentOwner = owner;
          _processStatus = ProcessingStatus.waiting;
          _sendResponse(
              owner, KeeperBody.createAuthStatus(ProcessStatus.success));
        } else {
          _processStatus = ProcessingStatus.error;
          _sendResponse(
              owner, KeeperBody.createAuthStatus(ProcessStatus.reject));
        }
        _currentAuthToken = null;
        notifyListeners();
        break;

      case OwnerMsgType.setShard:
        if (_currentOwner == owner) {
          try {
            await _guardianService.setShards(_managedShards);
            //TBD groupId
            _managedShards.add(
                SecretShard(owner: owner.data, secret: body.data, groupId: ''));
            _processStatus = ProcessingStatus.finished;
          } on Exception {
            _processStatus = ProcessingStatus.error;
          } finally {
            _currentOwner = null;
            notifyListeners();
          }
        } else {
          _currentOwner = null;
          _processStatus = ProcessingStatus.error;
          _sendResponse(
              owner, KeeperBody.createSaveDataStatus(ProcessStatus.reject));
          notifyListeners();
        }
        break;

      case OwnerMsgType.getShard:
        late final Uint8List shard;
        try {
          //TBD groupId
          shard = _managedShards
              .firstWhere((e) => PubKey(e.owner) == owner && e.groupId == '')
              .secret;
        } on StateError {
          shard = Uint8List(0);
        } finally {
          _sendResponse(owner, KeeperBody(KeeperMsgType.data, shard));
        }
        break;
    }
  }

  void _sendResponse(PubKey owner, KeeperBody body) => router.send(
      owner,
      KeeperPacket(
        Header(_topicOfThis, router.pubKey, owner),
        P2PCrypto.encrypt(owner, router.keyPair.secretKey, body.serialize()),
      ).serialize());

  Future<void> load() async {
    _managedShards = await _guardianService.getShards();
  }

  Future<void> clear() async {
    await _guardianService.clearShards();
    _managedShards.clear();
    notifyListeners();
  }

  void reset() {
    _currentAuthToken = null;
    _currentOwner = null;
    _processStatus = ProcessingStatus.notInited;
    notifyListeners();
  }

  void generateAuthToken() {
    _currentAuthToken = PubKey(getRandomBytes(PubKey.length));
    _processStatus = ProcessingStatus.inited;
    notifyListeners();
  }

  Uint8List getQRCode(Uint8List myPubKey) {
    var qr = [0, 0, 0, 0];
    qr.addAll(_currentAuthToken!.data);
    qr.addAll(myPubKey);
    qr.addAll(myPubKey); //TBD: add second pubKey
    return Uint8List.fromList(qr);
  }
}
