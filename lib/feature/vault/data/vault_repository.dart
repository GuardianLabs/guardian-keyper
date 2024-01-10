import 'package:hive/hive.dart';

import 'package:guardian_keyper/data/repositories/settings_repository.dart';
import 'package:guardian_keyper/feature/vault/domain/entity/vault.dart';

export 'package:get_it/get_it.dart';

export 'package:guardian_keyper/feature/vault/domain/entity/vault.dart';

typedef VaultRepositoryEvent = ({
  String key,
  Vault? vault,
  bool isDeleted,
});

/// Depends on [SettingsRepository]
class VaultRepository {
  late final Box<Vault> _storage;

  Iterable<Vault> get values => _storage.values;

  Future<VaultRepository> init({required HiveCipher encryptionCipher}) async {
    Hive.registerAdapter<Vault>(VaultModelAdapter());
    _storage = await Hive.openBox<Vault>(
      'vaults',
      encryptionCipher: encryptionCipher,
    );
    return this;
  }

  Future<void> close() async {}

  Future<void> clear() => _storage.clear();

  Future<void> flush() => _storage.flush();

  Vault? get(String key) => _storage.get(key);

  bool containsKey(String key) => _storage.containsKey(key);

  Future<Vault> put(String key, Vault value) async {
    await _storage.put(key, value);
    return value;
  }

  Future<void> delete(String key) => _storage.delete(key);

  Stream<VaultRepositoryEvent> watch([String? key]) =>
      _storage.watch(key: key).map((e) => (
            key: e.key as String,
            vault: e.value as Vault?,
            isDeleted: e.deleted,
          ));
}

class VaultModelAdapter extends TypeAdapter<Vault> {
  @override
  final typeId = Vault.typeId;

  @override
  Vault read(BinaryReader reader) => Vault.fromBytes(reader.readByteList());

  @override
  void write(BinaryWriter writer, Vault obj) =>
      writer.writeByteList(obj.toBytes());
}
