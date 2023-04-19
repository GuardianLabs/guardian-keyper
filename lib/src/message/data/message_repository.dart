import 'dart:typed_data';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:guardian_keyper/src/core/data/preferences_manager.dart';

import '../domain/message_model.dart';

export 'package:hive_flutter/hive_flutter.dart';

export '../../core/domain/entity/core_model.dart';

typedef MessageRepository = Box<MessageModel>;

Future<MessageRepository> getMessageRepository() async {
  Hive.registerAdapter<MessageModel>(MessageModelAdapter());
  final cipher = HiveAesCipher(
      await GetIt.I<PreferencesManager>().get<Uint8List>(keySeed) ??
          Uint8List(0));
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
