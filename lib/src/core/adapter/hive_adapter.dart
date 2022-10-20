import 'package:hive_flutter/hive_flutter.dart';

import '/src/core/model/core_model.dart';

class SettingsModelAdapter extends TypeAdapter<SettingsModel> {
  @override
  final typeId = SettingsModel.typeId;

  @override
  SettingsModel read(BinaryReader reader) =>
      SettingsModel.fromBytes(reader.readByteList());

  @override
  void write(BinaryWriter writer, SettingsModel obj) =>
      writer.writeByteList(obj.toBytes());
}

class SecretShardModelAdapter extends TypeAdapter<SecretShardModel> {
  @override
  final typeId = SecretShardModel.typeId;

  @override
  SecretShardModel read(BinaryReader reader) =>
      SecretShardModel.fromBytes(reader.readByteList());

  @override
  void write(BinaryWriter writer, SecretShardModel obj) =>
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
