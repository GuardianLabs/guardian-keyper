import 'package:hive_flutter/hive_flutter.dart';

import '/src/core/model/core_model.dart';

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
