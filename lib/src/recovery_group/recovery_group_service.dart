import 'dart:convert';
import 'package:p2plib/p2plib.dart' as p2p;
import 'package:sodium/sodium.dart' show KeyPair;

import '../core/service/kv_storage.dart';
import 'recovery_group_model.dart';

class RecoveryGroupService {
  const RecoveryGroupService(this._storage);

  static const _key = 'recovery_groups';

  final KVStorage _storage;

  Future<Map<String, RecoveryGroupModel>> getGroups() async {
    final groupsStr = await _storage.read(key: _key);
    if (groupsStr == null) return {};

    Map<String, dynamic> groupsMap = jsonDecode(groupsStr);
    groupsMap.updateAll((key, value) =>
        RecoveryGroupModel.fromJson(value as Map<String, dynamic>));

    return groupsMap.cast<String, RecoveryGroupModel>();
  }

  Future<void> setGroups(Map<String, RecoveryGroupModel> groups) async {
    final value = jsonEncode(groups, toEncodable: (Object? value) {
      switch (value.runtimeType) {
        case RecoveryGroupModel:
          return RecoveryGroupModel.toJson(value as RecoveryGroupModel);
        case RecoveryGroupGuardianModel:
          return RecoveryGroupGuardianModel.toJson(
              value as RecoveryGroupGuardianModel);
        case RecoveryGroupSecretModel:
          return RecoveryGroupSecretModel.toJson(
              value as RecoveryGroupSecretModel);
        default:
          throw UnsupportedError(value.runtimeType.toString());
      }
    });
    _storage.write(key: _key, value: value);
  }

  Future<void> clearGroups() async => _storage.delete(key: _key);

  Future<KeyPairModel> getKeyPair() async {
    final keyPairString = await _storage.read(key: 'key_pair');

    if (keyPairString == null) {
      final keyPair = p2p.P2PCrypto().sodium.crypto.box.keyPair() as KeyPair;

      final keyPairModel = KeyPairModel(
        privateKey: keyPair.secretKey.extractBytes(),
        publicKey: keyPair.publicKey,
      );
      await _storage.write(
        key: 'key_pair',
        value: KeyPairModel.toJson(keyPairModel),
      );
      return keyPairModel;
    }
    return KeyPairModel.fromJson(keyPairString);
  }
}
