import 'package:hive_flutter/hive_flutter.dart';

import '/src/core/model/core_model.dart';
import '/src/settings/settings_repository.dart';

export 'package:hive_flutter/hive_flutter.dart';

export '/src/settings/settings_repository.dart';

Future<void> registerRepositories() async {
  GetIt.I.registerSingleton<SettingsRepository>(SettingsRepository());

  // TBD: move Hive here
  await Hive.initFlutter('data_v1');
  Hive
    ..registerAdapter<MessageModel>(MessageModelAdapter())
    ..registerAdapter<RecoveryGroupModel>(RecoveryGroupModelAdapter());
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
