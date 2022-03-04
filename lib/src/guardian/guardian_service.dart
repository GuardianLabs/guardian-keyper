import 'dart:convert';

import '../core/service/kv_storage.dart';
import 'guardian_model.dart';

class GuardianService {
  const GuardianService({required this.storage});

  static const _guardianPath = 'guardian';

  final KVStorage storage;

  Future<Set<SecretShard>> getShards() async {
    final shardsStr = await storage.read(key: _guardianPath);
    if (shardsStr == null) return {};

    final shardsList = jsonDecode(shardsStr) as List;
    return shardsList.map((e) => SecretShard.fromJson(e)).toSet();
  }

  Future<void> setShards(Set<SecretShard> managedSecrets) async {
    final json = jsonEncode(managedSecrets.toList(),
        toEncodable: (Object? value) =>
            value is SecretShard ? SecretShard.toJson(value) : null);
    await storage.write(key: _guardianPath, value: json);
  }

  Future<void> clearShards() async => storage.delete(key: _guardianPath);
}
