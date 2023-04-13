import 'package:hive_flutter/hive_flutter.dart';

import 'vault_model.dart';

export 'package:hive_flutter/hive_flutter.dart';

export '/src/core/data/core_model.dart';

export 'vault_model.dart';

typedef VaultRepository = Box<VaultModel>;

Future<VaultRepository> getVaultRepository({
  required final HiveAesCipher cipher,
}) {
  Hive.registerAdapter<VaultModel>(VaultModelAdapter());
  return Hive.openBox<VaultModel>('vaults', encryptionCipher: cipher);
}

class VaultModelAdapter extends TypeAdapter<VaultModel> {
  @override
  final typeId = VaultModel.typeId;

  @override
  VaultModel read(BinaryReader reader) =>
      VaultModel.fromBytes(reader.readByteList());

  @override
  void write(BinaryWriter writer, VaultModel obj) =>
      writer.writeByteList(obj.toBytes());
}
