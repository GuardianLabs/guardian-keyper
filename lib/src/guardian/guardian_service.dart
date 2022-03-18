import 'dart:convert';
import 'dart:typed_data';

import '../core/service/kv_storage.dart';
import 'guardian_model.dart';

class GuardianService {
  const GuardianService({required this.storage});

  static const _secretShardsPath = 'secret_shards';
  static const _trustedPeersPath = 'trusted_peers';

  final KVStorage storage;

  Future<Set<Uint8List>> getTrustedPeers() async {
    final peersStr = await storage.read(key: _trustedPeersPath);
    if (peersStr == null) return {};

    final peerList = jsonDecode(peersStr) as List;
    return peerList.map((e) => base64Decode(e)).cast<Uint8List>().toSet();
  }

  Future<void> setTrustedPeers(Set<Uint8List> peers) async {
    await storage.write(
      key: _trustedPeersPath,
      value: jsonEncode(peers.map((e) => base64Encode(e)).toList()),
    );
  }

  Future<void> clearTrustedPeers() async =>
      storage.delete(key: _trustedPeersPath);

  Future<Set<SecretShard>> getSecretShards() async {
    final shardsStr = await storage.read(key: _secretShardsPath);
    if (shardsStr == null) return {};

    final shardsList = jsonDecode(shardsStr) as List;
    return shardsList.map((e) => SecretShard.fromJson(e)).toSet();
  }

  Future<void> setSecretShards(Set<SecretShard> managedSecrets) async {
    final json = jsonEncode(managedSecrets.toList(),
        toEncodable: (Object? value) =>
            value is SecretShard ? value.toJson() : null);
    await storage.write(key: _secretShardsPath, value: json);
  }

  Future<void> clearSecretShards() async =>
      storage.delete(key: _secretShardsPath);
}
