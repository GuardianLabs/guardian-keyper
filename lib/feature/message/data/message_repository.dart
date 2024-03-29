import 'package:hive/hive.dart';

import 'package:guardian_keyper/data/repositories/settings_repository.dart';
import 'package:guardian_keyper/feature/message/domain/entity/message_model.dart';

export 'package:get_it/get_it.dart';

typedef MessageRepositoryEvent = ({
  String key,
  MessageModel? message,
  bool isDeleted,
});

/// Depends on [SettingsRepository]
class MessageRepository {
  late final Box<MessageModel> _storage;

  Iterable<MessageModel> get values => _storage.values;

  Future<MessageRepository> init({required HiveCipher encryptionCipher}) async {
    Hive.registerAdapter<MessageModel>(MessageModelAdapter());
    _storage = await Hive.openBox<MessageModel>(
      'messages',
      encryptionCipher: encryptionCipher,
    );
    return this;
  }

  Future<void> close() async {
    await _storage.close();
  }

  MessageModel? get(String key) => _storage.get(key);

  bool containsKey(String key) => _storage.containsKey(key);

  Future<MessageModel> put(String key, MessageModel value) async {
    await _storage.put(key, value);
    return value;
  }

  Future<void> delete(String key) => _storage.delete(key);

  Stream<MessageRepositoryEvent> watch([String? key]) =>
      _storage.watch(key: key).map((e) => (
            key: e.key as String,
            message: e.value as MessageModel?,
            isDeleted: e.deleted,
          ));

  Future<void> prune() async {
    await _storage.deleteAll(
        _storage.values.where((e) => e.isForPrune).map((e) => e.aKey));
    await _storage.compact();
  }

  Future<void> flush() => _storage.flush();

  Future<void> clear() => _storage.clear();
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
