import 'dart:typed_data';
import 'package:hive/hive.dart';
import 'package:get_it/get_it.dart';

import 'package:guardian_keyper/data/services/preferences_service.dart';
import 'package:guardian_keyper/feature/vault/domain/entity/vault.dart';

export 'package:guardian_keyper/feature/vault/domain/entity/vault.dart';

typedef VaultRepositoryEvent = ({
  String key,
  Vault? vault,
  bool isDeleted,
});

/// Depends on [PreferencesService]
class VaultRepository {
  late final flush = _storage.flush;

  late final Box<Vault> _storage;

  Iterable<Vault> get values => _storage.values;

  Future<VaultRepository> init() async {
    final preferences = GetIt.I<PreferencesService>();
    Hive.init(preferences.pathDataDir);
    final seed = await preferences.get<Uint8List>(PreferencesKeys.keySeed);
    Hive.registerAdapter<Vault>(VaultModelAdapter());
    _storage = await Hive.openBox<Vault>(
      'vaults',
      encryptionCipher: HiveAesCipher(seed!),
    );
    return this;
  }

  Vault? get(String key) => _storage.get(key);

  bool containsKey(String key) => _storage.containsKey(key);

  Future<void> put(String key, Vault value) => _storage.put(key, value);

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
