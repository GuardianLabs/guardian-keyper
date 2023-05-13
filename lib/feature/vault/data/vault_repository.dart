import 'package:hive_flutter/hive_flutter.dart';

import 'package:guardian_keyper/domain/entity/vault_model.dart';

typedef VaultRepository = Box<VaultModel>;

Future<VaultRepository> getVaultRepository(final HiveAesCipher cipher) {
  Hive.registerAdapter<VaultModel>(VaultModelAdapter());
  return Hive.openBox<VaultModel>('vaults', encryptionCipher: cipher);
}

class VaultModelAdapter extends TypeAdapter<VaultModel> {
  @override
  final typeId = VaultModel.typeId;

  @override
  VaultModel read(final BinaryReader reader) =>
      VaultModel.fromBytes(reader.readByteList());

  @override
  void write(final BinaryWriter writer, final VaultModel obj) =>
      writer.writeByteList(obj.toBytes());
}
