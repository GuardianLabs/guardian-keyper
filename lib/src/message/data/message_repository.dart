import 'package:hive_flutter/hive_flutter.dart';

import '../domain/message_model.dart';

export 'package:hive_flutter/hive_flutter.dart';

export '/src/core/domain/core_model.dart';

typedef MessageRepository = Box<MessageModel>;

Future<MessageRepository> getMessageRepository({
  required final HiveAesCipher cipher,
}) {
  Hive.registerAdapter<MessageModel>(MessageModelAdapter());
  return Hive.openBox<MessageModel>('messages', encryptionCipher: cipher);
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
