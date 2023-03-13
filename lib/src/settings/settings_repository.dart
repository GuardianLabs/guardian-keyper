import 'dart:async';
import 'dart:typed_data';

import '/src/core/service/storage/flutter_secure_storage_service.dart';

class SettingsRepository {
  static const _keySeed = 'seed';
  static const _keyPassCode = 'pass_code';
  static const _keyDeviceName = 'device_name';
  static const _keyIsBootstrapEnabled = 'is_bootstrap_enabled';
  static const _keyIsBiometricsEnabled = 'is_biometrics_enabled';

  SettingsRepository({StorageService? storageService})
      : _storage = storageService ??
            FlutterSecureStorageService(storageName: 'settings');

  final StorageService _storage;

  Future<Uint8List> getSeedKey() =>
      _storage.getOr<Uint8List>(_keySeed, Uint8List(0));

  Future<Uint8List> setSeedKey(final Uint8List value) async {
    await _storage.set<Uint8List>(_keySeed, value);
    return value;
  }

  Future<String> getDeviceName() => _storage.getOr<String>(_keyDeviceName, '');

  Future<String> setDeviceName(final String value) async {
    await _storage.set<String>(_keyDeviceName, value);
    return value;
  }

  Future<String> getPassCode() => _storage.getOr<String>(_keyPassCode, '');

  Future<String> setPassCode(final String value) async {
    await _storage.set<String>(_keyPassCode, value);
    return value;
  }

  Future<bool> getIsBiometricsEnabled() =>
      _storage.getOr<bool>(_keyIsBiometricsEnabled, true);

  Future<bool> setIsBiometricsEnabled(final bool value) async {
    await _storage.set<bool>(_keyIsBiometricsEnabled, value);
    return value;
  }

  Future<bool> getIsBootstrapEnabled() =>
      _storage.getOr<bool>(_keyIsBootstrapEnabled, true);

  Future<bool> setIsBootstrapEnabled(final bool value) async {
    await _storage.set<bool>(_keyIsBootstrapEnabled, value);
    return value;
  }
}
