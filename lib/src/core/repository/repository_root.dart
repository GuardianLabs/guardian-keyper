import 'dart:typed_data';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '/src/core/model/core_model.dart';
import '/src/settings/settings_repository.dart';

export 'package:get_it/get_it.dart';
export 'package:flutter_bloc/flutter_bloc.dart';
export 'package:hive_flutter/hive_flutter.dart';

export '/src/core/model/core_model.dart';

class RepositoryRoot with WidgetsBindingObserver {
  static Future<RepositoryRoot> bootstrap({required Uint8List aesKey}) async {
    await Hive.initFlutter('data_v1');
    Hive
      ..registerAdapter<MessageModel>(MessageModelAdapter())
      ..registerAdapter<RecoveryGroupModel>(RecoveryGroupModelAdapter());

    final cipher = HiveAesCipher(aesKey);
    final repositoryRoot = RepositoryRoot()
      ..settingsRepository = SettingsRepository()
      ..messageRepository = await Hive.openBox<MessageModel>(
        MessageModel.boxName,
        encryptionCipher: cipher,
      )
      ..vaultRepository = await Hive.openBox<RecoveryGroupModel>(
        RecoveryGroupModel.boxName,
        encryptionCipher: cipher,
      );
    await repositoryRoot.settingsRepository.load();

    return repositoryRoot;
  }

  RepositoryRoot() {
    WidgetsBinding.instance.addObserver(this);
  }

  late final SettingsRepository settingsRepository;
  late final Box<RecoveryGroupModel> vaultRepository;
  late final Box<MessageModel> messageRepository;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state != AppLifecycleState.resumed) {
      await messageRepository.flush();
      await vaultRepository.flush();
    }
  }
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
