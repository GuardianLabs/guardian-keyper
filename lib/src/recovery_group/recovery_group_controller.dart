import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/widgets.dart' hide Router;
import 'package:p2plib/p2plib.dart';

import '../core/service/event_bus.dart';
import '../core/model/p2p_model.dart' hide PubKey;
import 'recovery_group_model.dart';
import 'recovery_group_service.dart';

class RecoveryGroupController extends TopicHandler with ChangeNotifier {
  static const _topicOfThis = 100;
  static const _topicSubscribeTo = 101;
  static const _networkTimeout = Duration(seconds: 10);

  final networkStream = StreamController<P2PPacketStream>.broadcast();
  final RecoveryGroupService _recoveryGroupService;
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

  @override
  Uint64List topics() => Uint64List.fromList([_topicSubscribeTo]);

  @override
  void onMessage(Uint8List data, Peer peer) {
    final header = Header.deserialize(data.sublist(0, Header.length - 1));
    networkStream.add(P2PPacketStream(
      requestStatus: RequestStatus.recieved,
      p2pPacket: P2PPacket.fromCbor(data.sublist(Header.length), header.srcKey),
    ));
  }

  Future<void> sendAuthRequest(QRCode guardianQRCode) async {
    final peerPubKey = PubKey(guardianQRCode.pubKey);
    networkStream
        .add(const P2PPacketStream(requestStatus: RequestStatus.sending));
    await router
        .sendTo(
            _topicOfThis,
            peerPubKey,
            P2PPacket(
              peerPubKey: peerPubKey,
              type: MessageType.authPeer,
              body: guardianQRCode.authToken,
            ).toCbor())
        .timeout(_networkTimeout,
            onTimeout: () => networkStream.add(
                const P2PPacketStream(requestStatus: RequestStatus.timeout)))
        .whenComplete(() => networkStream
            .add(const P2PPacketStream(requestStatus: RequestStatus.sent)))
        .onError((e, s) => networkStream.add(P2PPacketStream(
              requestStatus: RequestStatus.error,
              error: e,
              stackTrace: s,
            )));
  }

  Future<void> sendSetShardRequest(
    PubKey peerPubKey,
    Uint8List groupId,
    Uint8List secretShard,
  ) async {
    networkStream.add(P2PPacketStream(
      p2pPacket: P2PPacket.emptyBody(peerPubKey: peerPubKey),
      requestStatus: RequestStatus.sending,
    ));
    await router
        .sendTo(
            _topicOfThis,
            peerPubKey,
            P2PPacket(
              peerPubKey: peerPubKey,
              type: MessageType.setShard,
              body: SetShardPacket(
                groupId: groupId,
                secretShard: secretShard,
              ).toCbor(),
            ).toCbor())
        .timeout(_networkTimeout,
            onTimeout: () => networkStream.add(P2PPacketStream(
                  p2pPacket: P2PPacket.emptyBody(peerPubKey: peerPubKey),
                  requestStatus: RequestStatus.timeout,
                )))
        .whenComplete(() => networkStream.add(P2PPacketStream(
              p2pPacket: P2PPacket.emptyBody(peerPubKey: peerPubKey),
              requestStatus: RequestStatus.sent,
            )))
        .onError((e, s) => networkStream.add(P2PPacketStream(
              p2pPacket: P2PPacket.emptyBody(peerPubKey: peerPubKey),
              requestStatus: RequestStatus.error,
              error: e,
              stackTrace: s,
            )));
  }

  Future<void> sendGetShardRequest(
    PubKey peerPubKey,
    Uint8List groupId,
    Uint8List secretShard,
  ) async {
    networkStream.add(P2PPacketStream(
      p2pPacket: P2PPacket.emptyBody(peerPubKey: peerPubKey),
      requestStatus: RequestStatus.sending,
    ));
    await router
        .sendTo(
            _topicOfThis,
            peerPubKey,
            P2PPacket(
              peerPubKey: peerPubKey,
              type: MessageType.getShard,
              body: groupId,
            ).toCbor())
        .timeout(_networkTimeout,
            onTimeout: () => networkStream.add(P2PPacketStream(
                  p2pPacket: P2PPacket.emptyBody(peerPubKey: peerPubKey),
                  requestStatus: RequestStatus.timeout,
                )))
        .whenComplete(() => networkStream.add(P2PPacketStream(
              p2pPacket: P2PPacket.emptyBody(peerPubKey: peerPubKey),
              requestStatus: RequestStatus.sent,
            )))
        .onError((e, s) => networkStream.add(P2PPacketStream(
              p2pPacket: P2PPacket.emptyBody(peerPubKey: peerPubKey),
              requestStatus: RequestStatus.error,
              error: e,
              stackTrace: s,
            )));
  }

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
