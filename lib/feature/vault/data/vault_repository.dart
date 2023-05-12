import 'dart:typed_data';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:guardian_keyper/data/preferences_service.dart';
import 'package:guardian_keyper/domain/entity/vault_model.dart';

typedef VaultRepository = Box<VaultModel>;

Future<VaultRepository> getVaultRepository() async {
  Hive.registerAdapter<VaultModel>(VaultModelAdapter());
  return Hive.openBox<VaultModel>(
    'vaults',
    encryptionCipher: HiveAesCipher(
        await GetIt.I<PreferencesService>().get<Uint8List>(keySeed) ??
            Uint8List(0)),
  );
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
