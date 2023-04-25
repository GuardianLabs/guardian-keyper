import 'dart:typed_data';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:guardian_keyper/src/core/data/preferences_manager.dart';

import '../domain/message_model.dart';

export 'package:hive_flutter/hive_flutter.dart';
export 'package:guardian_keyper/src/core/domain/entity/core_model.dart';

typedef MessageRepository = Box<MessageModel>;

Future<MessageRepository> getMessageRepository() async {
  Hive.registerAdapter<MessageModel>(MessageModelAdapter());
  final cipher = HiveAesCipher(
      await GetIt.I<PreferencesManager>().get<Uint8List>(keySeed) ??
          Uint8List(0));
  final messageRepository = await Hive.openBox<MessageModel>(
    'messages',
    encryptionCipher: cipher,
  );
  _pruneMessages(messageRepository);
  return messageRepository;
}

Future<void> _pruneMessages(final MessageRepository messageRepository) async {
  if (messageRepository.isEmpty) return;
  final expired = messageRepository.values
      .where((e) =>
          e.isRequested &&
          (e.code == MessageCode.createGroup ||
              e.code == MessageCode.takeGroup) &&
          e.timestamp
              .isBefore(DateTime.now().subtract(const Duration(days: 1))))
      .toList(growable: false);
  await messageRepository.deleteAll(expired.map((e) => e.aKey));
  await messageRepository.compact();
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
