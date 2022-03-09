import 'dart:typed_data';
import 'package:flutter/widgets.dart' hide Router;
import 'package:p2plib/p2plib.dart';

import '../core/service/event_bus.dart';
import '../core/model/qr_code_model.dart';
import '../core/model/keeper_packet.dart';
import '../core/model/owner_packet.dart';
import 'recovery_group_model.dart';
import 'recovery_group_service.dart';

enum RequestStatus { idle, sending, sent, timeout, error }

class RecoveryGroupController extends TopicHandler with ChangeNotifier {
  static const _topicOfThis = 100;
  static const _topicSubscribeTo = 101;
  static const _networkTimeout = Duration(seconds: 10);

  final RecoveryGroupService _recoveryGroupService;
  final Map<PubKey, RequestStatus> _setShardRequestStatus = {};
  final Map<PubKey, Uint8List> _getShardRequestResponse = {};
  RequestStatus _authRequestStatus = RequestStatus.idle;
  Map<String, RecoveryGroupModel> _groups = {};

  RecoveryGroupController({
    required RecoveryGroupService recoveryGroupService,
    required EventBus eventBus,
    required Router router,
  })  : _recoveryGroupService = recoveryGroupService,
        super(router) {
    eventBus.on<RecoveryGroupClearCommand>().listen((event) => clear());
  }

  Map<String, RecoveryGroupModel> get groups => _groups;
  RequestStatus get authRequestStatus => _authRequestStatus;
  Map<PubKey, RequestStatus> get setShardRequestStatus =>
      _setShardRequestStatus;
  Map<PubKey, Uint8List> get getShardRequestResponse =>
      _getShardRequestResponse;

  @override
  void onStarted() {}

  @override
  Uint64List topics() => Uint64List.fromList([_topicSubscribeTo]);

  @override
  void onMessage(Uint8List data, Peer peer) {
    final packet = KeeperPacket.deserialize(data);
    final srcKey = packet.header.srcKey;
    final body = KeeperBody.deserialize(
        P2PCrypto.decrypt(srcKey, router.keyPair.secretKey, packet.body));

    switch (body.msgType) {
      case KeeperMsgType.authResult:
        if (_authRequestStatus == RequestStatus.sending) {
          _authRequestStatus = RequestStatus.sent;
          notifyListeners();
        }
        break;

      case KeeperMsgType.setShardResult:
        if (!_setShardRequestStatus.containsKey(srcKey)) return;
        if (_setShardRequestStatus[srcKey] != RequestStatus.sending) return;

        switch (ProcessStatus.values[body.data[0]]) {
          case ProcessStatus.success:
            _setShardRequestStatus[srcKey] = RequestStatus.sent;
            break;
          case ProcessStatus.timeoutError:
            _setShardRequestStatus[srcKey] = RequestStatus.timeout;
            break;
          default:
            _setShardRequestStatus[srcKey] = RequestStatus.error;
        }
        notifyListeners();
        break;

      case KeeperMsgType.getShardResult:
        _getShardRequestResponse[srcKey] = body.data;
        notifyListeners();
        break;
    }
  }

  void sendAuthRequest(QRCodeModel guardianQRCode) {
    _sendRequest(PubKey(guardianQRCode.pubKey),
            OwnerBody(OwnerMsgType.authPeer, guardianQRCode.authToken))
        .timeout(_networkTimeout, onTimeout: () {
      if (_authRequestStatus == RequestStatus.sending) {
        _authRequestStatus = RequestStatus.timeout;
      }
    });
    _authRequestStatus = RequestStatus.sending;
    notifyListeners();
  }

  void resetAuthRequest() => _authRequestStatus = RequestStatus.idle;

  void sendSetShardRequest(
    PubKey peerPubKey,
    Uint8List groupId,
    Uint8List secretShard,
  ) {
    _sendRequest(peerPubKey, OwnerBody(OwnerMsgType.setShard, secretShard))
        .timeout(_networkTimeout, onTimeout: () {
      if (_setShardRequestStatus[peerPubKey] == RequestStatus.sending) {
        _setShardRequestStatus[peerPubKey] = RequestStatus.timeout;
      }
    });
    _setShardRequestStatus[peerPubKey] = RequestStatus.sending;
    notifyListeners();
  }

  void resetSetShardRequests() => _setShardRequestStatus.clear();

  void sendGetShardRequest(PubKey peerPubKey, Uint8List groupId) {
    _sendRequest(peerPubKey, OwnerBody(OwnerMsgType.getShard, Uint8List(0)))
        .timeout(_networkTimeout);
  }

  void resetGetShardRequests() => _getShardRequestResponse.clear();

  Future<void> _sendRequest(PubKey peerPubKey, OwnerBody body) => router.send(
      peerPubKey,
      OwnerPacket(
        Header(_topicOfThis, router.pubKey, peerPubKey),
        P2PCrypto.encrypt(
            peerPubKey, router.keyPair.secretKey, body.serialize()),
      ).serialize());

  Future<void> load() async {
    _groups = await _recoveryGroupService.getGroups();
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
    if (_groups.containsKey(group.name)) {
      throw RecoveryGroupAlreadyExists();
    }
    _groups[group.name] = group;
    await _save();
  }

  Future<void> addGuardian(
    String groupName,
    RecoveryGroupGuardianModel guardian,
  ) async {
    if (!_groups.containsKey(groupName)) {
      throw RecoveryGroupDoesNotExist();
    }
    final group = _groups[groupName]!;
    _groups[groupName] = group.addGuardian(guardian);
    await _save();
  }

  Future<void> addSecret(
    String groupName,
    RecoveryGroupSecretModel secret,
  ) async {
    // TBD: do all checks
    // if (_groups.containsKey(groupName)) {
    //   throw RecoveryGroupAlreadyExists();
    // }
    final group = _groups[groupName]!;
    final updatedgroup = group.addSecret(secret);
    _groups[groupName] = updatedgroup;
    await _save();
  }
}

class RecoveryGroupAlreadyExists implements Exception {
  static const description = 'Group with given name already exists!';
}

class RecoveryGroupDoesNotExist implements Exception {
  static const description = 'Group with given name does not exist!';
}
