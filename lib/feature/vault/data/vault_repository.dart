import 'package:hive_flutter/hive_flutter.dart';

import 'package:guardian_keyper/feature/vault/domain/entity/vault.dart';

typedef VaultRepository = Box<Vault>;

Future<VaultRepository> getVaultRepository(final HiveAesCipher cipher) {
  Hive.registerAdapter<Vault>(VaultModelAdapter());
  return Hive.openBox<Vault>('vaults', encryptionCipher: cipher);
}

class VaultModelAdapter extends TypeAdapter<Vault> {
  @override
  final typeId = Vault.typeId;

  @override
  Vault read(final BinaryReader reader) =>
      Vault.fromBytes(reader.readByteList());

  @override
  void write(final BinaryWriter writer, final Vault obj) =>
      writer.writeByteList(obj.toBytes());
}
