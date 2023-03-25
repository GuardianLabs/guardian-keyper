import 'dart:typed_data';
import 'package:hive_flutter/hive_flutter.dart';

import 'core_model.dart';
import '/src/settings/data/settings_repository.dart';

export 'package:get_it/get_it.dart';
export 'package:hive_flutter/hive_flutter.dart';

export 'core_model.dart';
export '/src/settings/data/settings_repository.dart';

class RepositoryRoot {
  static Future<RepositoryRoot> bootstrap({required Uint8List aesKey}) async {
    await Hive.initFlutter('data_v1');
    Hive
      ..registerAdapter<MessageModel>(MessageModelAdapter())
      ..registerAdapter<VaultModel>(RecoveryGroupModelAdapter());

    final cipher = HiveAesCipher(aesKey);
    final repositoryRoot = RepositoryRoot()
      ..settingsRepository = SettingsRepository()
      ..messageRepository = await Hive.openBox<MessageModel>(
        MessageModel.boxName,
        encryptionCipher: cipher,
      )
      ..vaultRepository = await Hive.openBox<VaultModel>(
        VaultModel.boxName,
        encryptionCipher: cipher,
      );
    await repositoryRoot.settingsRepository.load();

    return repositoryRoot;
  }

  late final SettingsRepository settingsRepository;
  late final Box<VaultModel> vaultRepository;
  late final Box<MessageModel> messageRepository;
}

class RecoveryGroupModelAdapter extends TypeAdapter<VaultModel> {
  @override
  final typeId = VaultModel.typeId;

  @override
  VaultModel read(BinaryReader reader) =>
      VaultModel.fromBytes(reader.readByteList());

  @override
  void write(BinaryWriter writer, VaultModel obj) =>
      writer.writeByteList(obj.toBytes());
}

class MessageModelAdapter extends TypeAdapter<MessageModel> {
  @override
  final typeId = MessageModel.typeId;

  @override
  MessageModel read(BinaryReader reader) =>
      MessageModel.fromBytes(reader.readByteList());

  @override
  void write(BinaryWriter writer, MessageModel obj) =>
      writer.writeByteList(obj.toBytes());
}
