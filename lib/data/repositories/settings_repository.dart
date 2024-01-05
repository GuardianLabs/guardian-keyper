import 'dart:async';
import 'package:get_it/get_it.dart';

import 'package:guardian_keyper/data/services/preferences_service.dart';

export 'package:get_it/get_it.dart';
export 'package:guardian_keyper/data/enums.dart';

typedef SettingsRepositoryEvent<T extends Object> = ({
  PreferencesKeys key,
  T? value,
});

class SettingsRepository {
  final _cache = <PreferencesKeys, Object>{};
  final _preferencesService = GetIt.I<PreferencesService>();
  final _events = StreamController<SettingsRepositoryEvent>.broadcast();

  Future<T?> get<T extends Object>(
    PreferencesKeys key, {
    T? defaultValue,
  }) async =>
      _cache[key] as T? ?? await _preferencesService.get<T>(key);

  Future<T> put<T extends Object>(PreferencesKeys key, T value) async {
    await _preferencesService.set<T>(key, value);
    _events.add((key: key, value: value));
    _cache[key] = value;
    return value;
  }

  Future<T?> putNullable<T extends Object>(
    PreferencesKeys key,
    T? value,
  ) async {
    if (value == null) {
      await delete(key);
      return value;
    } else {
      return put(key, value);
    }
  }

  Future<void> delete(PreferencesKeys key) async {
    await _preferencesService.delete(key);
    _events.add((key: key, value: null));
    _cache.remove(key);
  }

  Stream<SettingsRepositoryEvent<T>> watch<T extends Object>([
    PreferencesKeys? key,
  ]) {
    final stream = key == null
        ? _events.stream
        : _events.stream.where((e) => e.key == key);
    return stream.map<SettingsRepositoryEvent<T>>((e) => (
          key: e.key,
          value: e.value as T?,
        ));
  }
}
