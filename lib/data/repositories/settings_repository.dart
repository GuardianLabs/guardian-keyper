import 'dart:async';
import 'package:hive/hive.dart';

enum SettingsRepositoryKeys {
  keyIsDarkModeOn,
}

typedef SettingsRepositoryEvent = ({
  String key,
  Object? value,
  bool isDeleted,
});

class SettingsRepository {
  late final Box<String> _storage;

  Future<SettingsRepository> init() async {
    _storage = await Hive.openBox<String>('settings');
    return this;
  }

  String? get(SettingsRepositoryKeys key, {String? defaultValue}) =>
      _storage.get(key.toString(), defaultValue: defaultValue);

  Future<void> put(SettingsRepositoryKeys key, String value) =>
      _storage.put(key.toString(), value);

  Future<void> delete(SettingsRepositoryKeys key) =>
      _storage.delete(key.toString());

  Stream<SettingsRepositoryEvent> watch([SettingsRepositoryKeys? key]) =>
      _storage.watch(key: key.toString()).map((e) => (
            key: e.key as String,
            value: e.value as Object?,
            isDeleted: e.deleted,
          ));

  Future<void> flush() => _storage.flush().then((value) => _storage.compact());
}
