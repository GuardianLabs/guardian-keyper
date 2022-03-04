import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart' hide Router;
import 'package:p2plib/p2plib.dart';

import '../core/service/event_bus.dart';
import 'guardian_model.dart';
import 'guardian_service.dart';
import 'service/keeper_handler.dart';

enum ProcessingStatus { notInited, inited, waiting, finished, error }

class GuardianController with ChangeNotifier {
  GuardianController({
    required GuardianService guardianService,
    required EventBus eventBus,
    required Router p2pRouter,
  })  : _guardianService = guardianService,
        _eventBus = eventBus {
    eventBus.on<RecoveryGroupClearCommand>().listen((event) => clear());
    _handler = KeeperHandler(
      router: p2pRouter,
      onAuthRequest: _onAuthRequest,
      onSetRequest: _onSaveRequest,
      onGetRequest: _onGetRequest,
    );
  }

  final GuardianService _guardianService;
  // ignore: unused_field
  final EventBus _eventBus;
  final _random = Random.secure();
  late final KeeperHandler _handler;
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
    _currentAuthToken = PubKey(Uint8List.fromList(
        Iterable.generate(PubKey.length, (x) => _random.nextInt(255))
            .toList()));
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

  // обработка запроса от owner'a на добавление текущего кипера
  void _onAuthRequest(PubKey owner, Uint8List authToken) async {
    if (PubKey(authToken) == _currentAuthToken) {
      _currentAuthToken = null;
      _currentOwner = owner;
      try {
        await _handler.sendAuthStatus(owner, ProcessStatus.success);
        _processStatus = ProcessingStatus.waiting;
      } on Exception {
        _processStatus = ProcessingStatus.error;
      } finally {
        notifyListeners();
      }
    } else {
      _handler.sendAuthStatus(owner, ProcessStatus.reject);
    }
  }

  // обработка запроса на сохранение данных
  void _onSaveRequest(PubKey owner, Uint8List secretChunk) async {
    if (_currentOwner == owner) {
      _currentOwner = null;
      _managedShards.add(SecretShard(
        owner: owner.data,
        secret: secretChunk,
        groupId: '', //TBD groupId
      ));
      try {
        await _guardianService.setShards(_managedShards);
        await _handler.sendSaveStatus(owner, ProcessStatus.success);
        _processStatus = ProcessingStatus.finished;
      } on Exception {
        _processStatus = ProcessingStatus.error;
      } finally {
        notifyListeners();
      }
    } else {
      _handler.sendSaveStatus(owner, ProcessStatus.reject);
    }
  }

  // обработка запроса на получение данных
  void _onGetRequest(PubKey owner) {
    try {
      _handler.sendShard(
        owner,
        _managedShards
            .firstWhere((e) =>
                PubKey(e.owner) == owner && e.groupId == '') //TBD groupId
            .secret,
      );
    } on StateError {
      _handler.sendShard(owner, Uint8List(0));
    }
  }
}
