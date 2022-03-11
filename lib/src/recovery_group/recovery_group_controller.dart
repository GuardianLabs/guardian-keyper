import 'dart:typed_data';
import 'package:flutter/widgets.dart' hide Router;
import 'package:p2plib/p2plib.dart';

import '../core/service/event_bus.dart';
import '../core/model/p2p_model.dart' hide PubKey;
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
  late PubKey _authRequestPeer;
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
    final p2pPacket = P2PPacket.fromCbor(data);
    final peerPubKey = p2pPacket.header.srcKey;

    switch (p2pPacket.type) {
      case MessageType.authPeer:
        if (_authRequestPeer != peerPubKey ||
            _authRequestStatus != RequestStatus.sending) return;
        _authRequestStatus = p2pPacket.status == MessageStatus.success
            ? RequestStatus.sent
            : RequestStatus.error;
        notifyListeners();
        break;

      case MessageType.setShard:
        if (!_setShardRequestStatus.containsKey(peerPubKey) ||
            _setShardRequestStatus[peerPubKey] != RequestStatus.sending) return;
        _setShardRequestStatus[peerPubKey] =
            p2pPacket.status == MessageStatus.success
                ? RequestStatus.sent
                : RequestStatus.error;
        notifyListeners();
        break;

      case MessageType.getShard:
        if (p2pPacket.status != MessageStatus.success) return;
        _getShardRequestResponse[peerPubKey] = p2pPacket.body;
        notifyListeners();
        break;
      default:
    }
  }

  void sendAuthRequest(QRCode guardianQRCode) {
    final peerPubKey = PubKey(guardianQRCode.pubKey);
    router
        .send(
            peerPubKey,
            P2PPacket(
              header: Header(_topicOfThis, router.pubKey, peerPubKey),
              type: MessageType.authPeer,
              body: guardianQRCode.authToken,
            ).toCbor())
        .onError(
            (error, stackTrace) => _authRequestStatus = RequestStatus.error)
        .timeout(
      _networkTimeout,
      onTimeout: () {
        if (_authRequestStatus == RequestStatus.sending) {
          _authRequestStatus = RequestStatus.timeout;
        }
      },
    );
    _authRequestStatus = RequestStatus.sending;
    notifyListeners();
  }

  void resetAuthRequest() => _authRequestStatus = RequestStatus.idle;

  void sendSetShardRequest(
    PubKey peerPubKey,
    Uint8List groupId,
    Uint8List secretShard,
  ) {
    router
        .send(
            peerPubKey,
            P2PPacket(
              header: Header(_topicOfThis, router.pubKey, peerPubKey),
              type: MessageType.setShard,
              body: SetShardPacket(
                groupId: groupId,
                secretShard: secretShard,
              ).toCbor(),
            ).toCbor())
        .onError((error, stackTrace) =>
            _setShardRequestStatus[peerPubKey] = RequestStatus.error)
        .timeout(
      _networkTimeout,
      onTimeout: () {
        if (_setShardRequestStatus[peerPubKey] == RequestStatus.sending) {
          _setShardRequestStatus[peerPubKey] = RequestStatus.timeout;
        }
      },
    );
    _setShardRequestStatus[peerPubKey] = RequestStatus.sending;
    notifyListeners();
  }

  void resetSetShardRequests() => _setShardRequestStatus.clear();

  void sendGetShardRequest(PubKey peerPubKey, Uint8List groupId) {
    router
        .send(
            peerPubKey,
            P2PPacket(
              header: Header(_topicOfThis, router.pubKey, peerPubKey),
              body: groupId,
            ).toCbor())
        .timeout(_networkTimeout);
  }

  void resetGetShardRequests() => _getShardRequestResponse.clear();

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
