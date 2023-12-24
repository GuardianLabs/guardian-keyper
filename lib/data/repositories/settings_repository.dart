import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:hive/hive.dart';
import 'package:flutter/widgets.dart';

export 'package:get_it/get_it.dart';

enum SettingsRepositoryKeys {
  keyIsDarkModeOn,
  keyIsUnderstandingShardsHidden,
  keyIsSecretRestoreExplainerHidden,
}

typedef SettingsRepositoryEvent<T extends Object> = ({
  SettingsRepositoryKeys key,
  T? value,
});

class SettingsRepository with WidgetsBindingObserver {
  final _events = StreamController<SettingsRepositoryEvent>.broadcast();

  late final Box<String> _storage;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.paused:
        _storage.flush();
      case _:
    }
  }

  Future<SettingsRepository> init() async {
    _storage = await Hive.openBox<String>('settings');
    WidgetsBinding.instance.addObserver(this);
    return this;
  }

  Future<void> dispose() async {
    WidgetsBinding.instance.removeObserver(this);
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
    _events.add((key: key, value: value));
    return value;
  }

  Future<T?> putNullable<T extends Object>(
    SettingsRepositoryKeys key,
    T? value,
  ) async {
    if (value == null) {
      await delete(key);
      return value;
    } else {
      return put(key, value);
    }
  }

  Future<void> delete(SettingsRepositoryKeys key) async {
    await _storage.delete(key.name);
    _events.add((key: key, value: null));
  }

  Stream<SettingsRepositoryEvent<T>> watch<T extends Object>(
    SettingsRepositoryKeys key,
  ) =>
      _events.stream
          .where((e) => e.key == key)
          .map<SettingsRepositoryEvent<T>>((e) => (
                key: key,
                value: e.value as T?,
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
