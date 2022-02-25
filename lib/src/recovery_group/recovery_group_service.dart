import 'dart:convert';

import '../core/service/kv_storage.dart';
import 'recovery_group_model.dart';

class RecoveryGroupService {
  const RecoveryGroupService({required KVStorage storage}) : _storage = storage;

  static const _recoveryGroupsPath = 'recovery_groups';

  final KVStorage _storage;

  Future<Map<String, RecoveryGroupModel>> getGroups() async {
    final groupsStr = await _storage.read(key: _recoveryGroupsPath);
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
    _storage.write(key: _recoveryGroupsPath, value: value);
  }

  Future<void> clearGroups() async => _storage.delete(key: _recoveryGroupsPath);
}
