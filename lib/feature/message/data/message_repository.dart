import 'package:hive_flutter/hive_flutter.dart';

import 'package:guardian_keyper/feature/message/domain/entity/message_model.dart';

typedef MessageRepository = Box<MessageModel>;

Future<MessageRepository> getMessageRepository(final HiveAesCipher cipher) {
  Hive.registerAdapter<MessageModel>(MessageModelAdapter());
  return Hive.openBox<MessageModel>('messages', encryptionCipher: cipher);
}

class MessageModelAdapter extends TypeAdapter<MessageModel> {
  @override
  final typeId = MessageModel.typeId;

  @override
  MessageModel read(final BinaryReader reader) =>
      MessageModel.fromBytes(reader.readByteList());

  @override
  void write(final BinaryWriter writer, final MessageModel obj) =>
      writer.writeByteList(obj.toBytes());
}
