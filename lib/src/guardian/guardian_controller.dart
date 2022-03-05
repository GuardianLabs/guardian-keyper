import 'dart:typed_data';
import 'package:flutter/material.dart' hide Router;
import 'package:p2plib/p2plib.dart';

import '../core/utils.dart';
import '../core/service/event_bus.dart';
import '../p2pnetwork/keeper_handler.dart';
import 'guardian_model.dart';
import 'guardian_service.dart';

enum ProcessingStatus { notInited, inited, waiting, finished, error }

class GuardianController with ChangeNotifier {
  GuardianController({
    required GuardianService guardianService,
    required EventBus eventBus,
    required Router p2pRouter,
  }) : _guardianService = guardianService {
    eventBus.on<RecoveryGroupClearCommand>().listen((event) => clear());
    handler = KeeperHandler(
      router: p2pRouter,
      onAuthRequest: _onAuthRequest,
      onSetRequest: _onSetRequest,
      onGetRequest: _onGetRequest,
    );
  }

  final GuardianService _guardianService;
  late final KeeperHandler handler;

  PubKey? _currentAuthToken;
  PubKey? _currentOwner;
  ProcessingStatus _processStatus = ProcessingStatus.notInited;
  Set<SecretShard> _managedShards = {};

  ProcessingStatus get processStatus => _processStatus;

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

  Future<bool> _onAuthRequest(PubKey owner, Uint8List authToken) async {
    if (PubKey(authToken) != _currentAuthToken) {
      _processStatus = ProcessingStatus.error;
      notifyListeners();
      return false;
    }
    _currentAuthToken = null;
    _currentOwner = owner;
    _processStatus = ProcessingStatus.waiting;
    notifyListeners();
    return true;
  }

  Future<bool> _onSetRequest(PubKey owner, Uint8List secretChunk) async {
    if (_currentOwner != owner) {
      _processStatus = ProcessingStatus.error;
      notifyListeners();
      return false;
    }

    try {
      await _guardianService.setShards(_managedShards);
    } on Exception {
      _processStatus = ProcessingStatus.error;
      notifyListeners();
      return false;
    }

    _currentOwner = null;
    _managedShards.add(SecretShard(
      owner: owner.data,
      secret: secretChunk,
      groupId: '', //TBD groupId
    ));
    _processStatus = ProcessingStatus.finished;
    notifyListeners();
    return true;
  }

  Future<Uint8List> _onGetRequest(PubKey owner) async {
    try {
      final shard = _managedShards
          .firstWhere(
              (e) => PubKey(e.owner) == owner && e.groupId == '') //TBD groupId
          .secret;
      return shard;
    } on StateError {
      return Uint8List(0);
    }
  }
}
