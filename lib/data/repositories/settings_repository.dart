import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:hive/hive.dart';

enum SettingsRepositoryKeys {
  keyIsDarkModeOn,
  keyIsUnderstandingShardsHidden,
}

typedef SettingsRepositoryEvent<T extends Object> = ({
  String key,
  T? value,
  bool isDeleted,
});

class SettingsRepository {
  late final Box<String> _storage;

  Future<SettingsRepository> init() async {
    _storage = await Hive.openBox<String>('settings');
    return this;
  }

  T? get<T extends Object>(
    SettingsRepositoryKeys key, {
    T? defaultValue,
  }) {
    final value = _storage.get(key.toString());
    return value == null
        ? defaultValue
        : switch (T) {
            const (String) => value as T,
            const (int) => int.parse(value) as T,
            const (bool) => bool.parse(value) as T,
            const (Uint8List) => base64Decode(value) as T,
            _ => throw const SettingsValueFormatException(),
          };
  }

  Future<T> put<T extends Object>(SettingsRepositoryKeys key, T value) async {
    await switch (T) {
      const (int) ||
      const (bool) ||
      const (String) =>
        _storage.put(key.name, value.toString()),
      const (Uint8List) =>
        _storage.put(key.name, base64UrlEncode(value as Uint8List)),
      _ => throw const SettingsValueFormatException(),
    };
    return value;
  }

  Future<void> delete(SettingsRepositoryKeys key) =>
      _storage.delete(key.toString());

  Stream<SettingsRepositoryEvent<T>> watch<T extends Object>([
    SettingsRepositoryKeys? key,
  ]) =>
      _storage
          .watch(key: key.toString())
          .map<SettingsRepositoryEvent<T>>((e) => (
                key: e.key as String,
                value: e.value as T?,
                isDeleted: e.deleted,
              ));

  Future<void> flush() => _storage.flush().then((value) => _storage.compact());
}

class SettingsValueFormatException extends FormatException {
  const SettingsValueFormatException() : super('Unsupported value type');
}
