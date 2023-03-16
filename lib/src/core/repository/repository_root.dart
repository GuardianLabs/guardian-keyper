import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '/src/core/model/core_model.dart';
import '/src/settings/settings_repository.dart';

export 'package:get_it/get_it.dart';
export 'package:flutter_bloc/flutter_bloc.dart';
export 'package:hive_flutter/hive_flutter.dart';

class RepositoryRoot {
  static Future<RepositoryRoot> init() async {
    final settingsRepository = SettingsRepository();
    await settingsRepository.init();

    await Hive.initFlutter('data_v1');
    Hive
      ..registerAdapter<MessageModel>(MessageModelAdapter())
      ..registerAdapter<RecoveryGroupModel>(RecoveryGroupModelAdapter());

    final cipher = HiveAesCipher(await settingsRepository.getSeed());
    final repositoryRoot = RepositoryRoot()
      ..settingsRepository = settingsRepository
      ..messageRepository = await Hive.openBox<MessageModel>(
        MessageModel.boxName,
        encryptionCipher: cipher,
      )
      ..vaultRepository = await Hive.openBox<RecoveryGroupModel>(
        RecoveryGroupModel.boxName,
        encryptionCipher: cipher,
      );
    GetIt.I.registerSingleton<RepositoryRoot>(repositoryRoot);
    return repositoryRoot;
  }

  late final SettingsRepository settingsRepository;
  late final Box<RecoveryGroupModel> vaultRepository;
  late final Box<MessageModel> messageRepository;
}

class RecoveryGroupModelAdapter extends TypeAdapter<RecoveryGroupModel> {
  @override
  final typeId = RecoveryGroupModel.typeId;

  @override
  RecoveryGroupModel read(BinaryReader reader) =>
      RecoveryGroupModel.fromBytes(reader.readByteList());

  @override
  void write(BinaryWriter writer, RecoveryGroupModel obj) =>
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
