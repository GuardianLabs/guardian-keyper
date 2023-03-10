import 'dart:async';
import 'dart:typed_data';

import '/src/core/repository/repository_base.dart';

export 'package:get_it/get_it.dart';

class SettingsRepository extends RepositoryBase {
  static const _keySeed = 'seed';
  static const _keyPassCode = 'pass_code';
  static const _keyDeviceName = 'device_name';
  static const _keyIsBootstrapEnabled = 'is_bootstrap_enabled';
  static const _keyIsBiometricsEnabled = 'is_biometrics_enabled';

  static final _storage = RepositoryBase.getStorage('settings');

  const SettingsRepository();

  @override
  KVStorage get storage => _storage;

  Future<Uint8List> getSeedKey() => get<Uint8List>(_keySeed);

  Future<Uint8List> setSeedKey(final Uint8List value) =>
      set<Uint8List>(_keySeed, value);

  Future<String> getDeviceName() => get<String>(_keyDeviceName);

  Future<String> setDeviceName(final String value) =>
      set<String>(_keyDeviceName, value);

  Future<String> getPassCode() => get<String>(_keyPassCode);

  Future<String> setPassCode(final String value) =>
      set<String>(_keyPassCode, value);

  Future<bool> getIsBiometricsEnabled() => get<bool>(_keyIsBiometricsEnabled);

  Future<bool> setIsBiometricsEnabled(final bool value) =>
      set<bool>(_keyIsBiometricsEnabled, value);

  Future<bool> getIsBootstrapEnabled() => get<bool>(_keyIsBootstrapEnabled);

  Future<bool> setIsBootstrapEnabled(final bool value) =>
      set<bool>(_keyIsBootstrapEnabled, value);
}
