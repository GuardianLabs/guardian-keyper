import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:hive/hive.dart';

enum SettingsRepositoryKeys {
  keyIsDarkModeOn,
  keyIsUnderstandingShardsHidden,
  keyIsSecretRestoreExplainerHidden,
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
    final value = _storage.get(key.name);
    return value == null
        ? defaultValue
        : switch (T) {
            String => value as T,
            int => int.tryParse(value) as T?,
            bool => bool.tryParse(value) as T?,
            double => double.tryParse(value) as T?,
            Uint8List => _tryParseBase64(value) as T?,
            _ => throw const SettingsValueFormatException(),
          };
  }

  Future<T> put<T extends Object>(SettingsRepositoryKeys key, T value) async {
    switch (T) {
      case int || bool || double || String:
        await _storage.put(key.name, value.toString());
      case Uint8List:
        await _storage.put(key.name, base64UrlEncode(value as Uint8List));
      default:
        throw const SettingsValueFormatException();
    }
    return value;
  }

  Future<T?> putNullable<T extends Object>(
    SettingsRepositoryKeys key,
    T? value,
  ) async {
    if (value == null) {
      await _storage.delete(key.name);
    } else {
      await put(key, value);
    }
    return value;
  }

  Future<void> delete(SettingsRepositoryKeys key) => _storage.delete(key.name);

  Stream<SettingsRepositoryEvent<T>> watch<T extends Object>([
    SettingsRepositoryKeys? key,
  ]) =>
      _storage.watch(key: key?.name).map<SettingsRepositoryEvent<T>>((e) => (
            key: e.key as String,
            value: e.value as T?,
            isDeleted: e.deleted,
          ));

  Future<void> clear() => _storage.clear().then((_) => _storage.compact());

  Future<void> flush() => _storage.flush().then((_) => _storage.compact());

  Uint8List? _tryParseBase64(String? value) {
    if (value == null) return null;
    try {
      return base64Decode(value);
    } catch (_) {
      return null;
    }
  }
}

class SettingsValueFormatException extends FormatException {
  const SettingsValueFormatException() : super('Unsupported value type');
}
