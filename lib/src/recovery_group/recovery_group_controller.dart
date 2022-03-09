import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/widgets.dart' hide Router;
import 'package:p2plib/p2plib.dart';

import '../core/service/event_bus.dart';
import '../core/model/qr_code_model.dart';
import '../core/model/keeper_packet.dart';
import '../core/model/owner_packet.dart';
import 'recovery_group_model.dart';
import 'recovery_group_service.dart';

enum AuthRequestStatus { idle, sending, sent, timeout }

class RecoveryGroupController extends TopicHandler with ChangeNotifier {
  static const _topicOfThis = 100;
  static const _topicSubscribeTo = 101;
  static const defaultTimeout = Duration(seconds: 10);

  final RecoveryGroupService _recoveryGroupService;
  final Map<PubKey, Completer> _statusCompleters = {};
  final Map<PubKey, Completer<Uint8List>> _dataCompleters = {};
  late Map<String, RecoveryGroupModel> _groups;
  AuthRequestStatus _authRequestStatus = AuthRequestStatus.idle;

  RecoveryGroupController({
    required RecoveryGroupService recoveryGroupService,
    required EventBus eventBus,
    required Router router,
  })  : _recoveryGroupService = recoveryGroupService,
        super(router) {
    eventBus.on<RecoveryGroupClearCommand>().listen((event) => clear());
  }

  Map<String, RecoveryGroupModel> get groups => _groups;
  AuthRequestStatus get authRequestStatus => _authRequestStatus;

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
      case KeeperMsgType.addKeeperResult:
        if (_authRequestStatus == AuthRequestStatus.sending) {
          _authRequestStatus = AuthRequestStatus.sent;
          notifyListeners();
        }
        break;

      case KeeperMsgType.saveDataResult:
        final completer = _statusCompleters[srcKey];
        if (completer == null) return;

        final status = ProcessStatus.values[body.data[0]];
        status == ProcessStatus.success
            ? completer.complete()
            : completer.completeError(status);
        _statusCompleters.remove(srcKey);
        break;

      case KeeperMsgType.data:
        final completer = _dataCompleters[srcKey];
        if (completer == null) return;

        completer.complete(body.data);
        _dataCompleters.remove(srcKey);
        break;
    }
  }

  void sendAuthRequest(QRCodeModel guardianQRCode) {
    _sendRequest(PubKey(guardianQRCode.pubKey),
            OwnerBody(OwnerMsgType.authPeer, guardianQRCode.authToken))
        .timeout(defaultTimeout, onTimeout: () {
      if (_authRequestStatus == AuthRequestStatus.sending) {
        _authRequestStatus = AuthRequestStatus.timeout;
      }
    });
    _authRequestStatus = AuthRequestStatus.sending;
    notifyListeners();
  }

  void resetAuthRequest() => _authRequestStatus = AuthRequestStatus.idle;

  // оправить фрагмент данных на хранение
  Future<void> sendSetShardRequest(
    PubKey peerPubKey,
    Uint8List secretShard, {
    Duration timeout = defaultTimeout,
  }) async {
    final completer = Completer();
    _statusCompleters[peerPubKey] = completer;
    await _sendRequest(
        peerPubKey, OwnerBody(OwnerMsgType.setShard, secretShard));

    return completer.future.timeout(timeout, onTimeout: () {
      _statusCompleters.remove(peerPubKey);
      throw TimeoutException('[OwnerHandler] send shard request timeout');
    });
  }

  // оправить запрос на получение фрагмента данных
  Future<Uint8List> _sendGetShardRequest(
    PubKey peerPubKey, {
    Duration timeout = defaultTimeout,
  }) async {
    final completer = Completer<Uint8List>();
    _dataCompleters[peerPubKey] = completer;
    await _sendRequest(
        peerPubKey, OwnerBody(OwnerMsgType.getShard, Uint8List(0)));

    return completer.future.timeout(timeout, onTimeout: () {
      _dataCompleters.remove(peerPubKey);
      throw TimeoutException('[OwnerHandler] request shard timeout');
    });
  }

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
