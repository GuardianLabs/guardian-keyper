// ignore_for_file: unused_field

import 'dart:typed_data';
import 'package:p2plib/p2plib.dart' as p2p;
// import 'package:sodium/sodium.dart' show KeyPair, SecureKey;

// import '../core/model/pub_key.dart';
import '../core/service/kv_storage.dart';

import 'guardian_model.dart';
import 'service/keeper_handler.dart';

class GuardianService {
  GuardianService({
    required KVStorage storage,
    required p2p.Router router,
  }) : _storage = storage {
    handler = KeeperHandler(router)
      ..onAddKeeperRequest = _onAddKeeperRequest
      ..onSaveRequest = _onSaveRequest
      ..onGetRequest = _onGetRequest;
  }

  static const _guardianPath = 'guardian';

  final KVStorage _storage;
  late KeeperHandler handler;

  AuthToken? _currentToken;
  final Map<p2p.PubKey, StoredSecret?> _managedSecrets = {};

  // обработка запроса от owner'a на добавление текущего кипера
  void _onAddKeeperRequest(p2p.PubKey owner, Uint8List token) {
    final authToken = AuthToken(token);
    if (authToken == _currentToken) {
      _managedSecrets[owner] = null;
      handler.sendAddKeeperStatus(owner, p2p.ProcessStatus.success);
    } else {
      handler.sendAddKeeperStatus(owner, p2p.ProcessStatus.reject);
    }
  }

  // обработка запроса на сохранение данных
  void _onSaveRequest(p2p.PubKey owner, Uint8List data) {
    // owner не добавлял текущего кипера
    if (!_managedSecrets.containsKey(owner)) {
      handler.sendSaveStatus(owner, p2p.ProcessStatus.reject);
      return;
    }
    _managedSecrets[owner] = StoredSecret(secret: data);
    handler.sendSaveStatus(owner, p2p.ProcessStatus.success);
  }

  // обработка запроса на получение данных
  void _onGetRequest(p2p.PubKey owner) {
    if (_managedSecrets.containsKey(owner) && _managedSecrets[owner] != null) {
      final data = _managedSecrets[owner]!.secret;
      handler.sendShard(owner, data);
    } else {
      handler.sendShard(owner, Uint8List(0));
    }
  }
}
