// ignore_for_file: unused_field

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:p2plib/p2plib.dart' as p2p;

import '../core/service/event_bus.dart';
import 'guardian_model.dart';
import 'guardian_service.dart';
import 'service/keeper_handler.dart';

class GuardianController with ChangeNotifier {
  GuardianController({
    required GuardianService guardianService,
    required EventBus eventBus,
    required p2p.Router p2pRouter,
  })  : _guardianService = guardianService,
        _eventBus = eventBus {
    _handler = KeeperHandler(
      router: p2pRouter,
      onAddKeeperRequest: _onAddKeeperRequest,
      onSaveRequest: _onSaveRequest,
      onGetRequest: _onGetRequest,
    );
  }

  final GuardianService _guardianService;
  final EventBus _eventBus;
  late KeeperHandler _handler;
  AuthToken? _currentToken;
  final Map<p2p.PubKey, StoredSecret?> _managedSecrets = {};

  // Future<void> load() async {
  //   notifyListeners();
  // }

  AuthToken generateAuthToken() {
    _currentToken = AuthToken.generate();
    return _currentToken!;
  }

  // обработка запроса от owner'a на добавление текущего кипера
  void _onAddKeeperRequest(p2p.PubKey owner, Uint8List authToken) {
    if (AuthToken(authToken) == _currentToken) {
      _managedSecrets[owner] = null;
      _handler.sendAddKeeperStatus(owner, p2p.ProcessStatus.success);
    } else {
      _handler.sendAddKeeperStatus(owner, p2p.ProcessStatus.reject);
    }
  }

  // обработка запроса на сохранение данных
  void _onSaveRequest(p2p.PubKey owner, Uint8List secretChunk) {
    // owner не добавлял текущего кипера
    if (!_managedSecrets.containsKey(owner)) {
      _handler.sendSaveStatus(owner, p2p.ProcessStatus.reject);
      return;
    }
    _managedSecrets[owner] = StoredSecret(secret: secretChunk);
    _handler.sendSaveStatus(owner, p2p.ProcessStatus.success);
  }

  // обработка запроса на получение данных
  void _onGetRequest(p2p.PubKey owner) {
    if (_managedSecrets.containsKey(owner) && _managedSecrets[owner] != null) {
      final data = _managedSecrets[owner]!.secret;
      _handler.sendShard(owner, data);
    } else {
      _handler.sendShard(owner, Uint8List(0));
    }
  }

  // void clearRecoveryGroups() => _eventBus.fire(RecoveryGroupClearEvent());
}
