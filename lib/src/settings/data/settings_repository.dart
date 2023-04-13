import 'dart:async';
import 'dart:typed_data';

import '/src/core/infrastructure/secure_storage.dart';

import '../domain/settings_model.dart';

enum SettingsRepositoryKeys {
  seed,
  passCode,
  deviceName,
  isBootstrapEnabled,
  isBiometricsEnabled,
}

class SettingsEvent {
  final SettingsRepositoryKeys key;
  final SettingsModel value;

  const SettingsEvent({required this.key, required this.value});
}

class SettingsRepository {
  SettingsRepository({
    required String defaultName,
    SecureStorage? storageService,
  })  : _defaultName = defaultName,
        _storage = storageService ?? SecureStorage(storage: Storages.settings);

  SettingsModel get settings => _settings;

  Stream<SettingsEvent> get stream => _updatesStreamController.stream;

  final String _defaultName;
  final SecureStorage _storage;

  late SettingsModel _settings;

  final _updatesStreamController = StreamController<SettingsEvent>.broadcast();

  Future<SettingsModel> load() async {
    // Ugly hack to fix first read returns null
    await _storage.get<Uint8List>(SettingsRepositoryKeys.seed);
    _settings = SettingsModel(
      seed: await _storage.getOr<Uint8List>(
        SettingsRepositoryKeys.seed,
        Uint8List(0),
      ),
      passCode: await _storage.getOr<String>(
        SettingsRepositoryKeys.passCode,
        '',
      ),
      deviceName: await _storage.getOr<String>(
        SettingsRepositoryKeys.deviceName,
        _defaultName,
      ),
      isBootstrapEnabled: await _storage.getOr<bool>(
        SettingsRepositoryKeys.isBootstrapEnabled,
        true,
      ),
      isBiometricsEnabled: await _storage.getOr<bool>(
        SettingsRepositoryKeys.isBiometricsEnabled,
        true,
      ),
    );
    return _settings;
  }

  Future<void> setSeed(final Uint8List value) async {
    if (_settings.seed.isEmpty) {
      await _storage.set<Uint8List>(SettingsRepositoryKeys.seed, value);
    }
  }

  Future<void> setDeviceName(final String value) async {
    await _storage.set<String>(SettingsRepositoryKeys.deviceName, value);
    _settings = _settings.copyWith(deviceName: value);
    _updatesStreamController.add(SettingsEvent(
      key: SettingsRepositoryKeys.deviceName,
      value: _settings,
    ));
  }

  Future<void> setPassCode(final String value) async {
    await _storage.set<String>(SettingsRepositoryKeys.passCode, value);
    _settings = _settings.copyWith(passCode: value);
    _updatesStreamController.add(SettingsEvent(
      key: SettingsRepositoryKeys.passCode,
      value: _settings,
    ));
  }

  Future<void> setIsBootstrapEnabled(final bool value) async {
    await _storage.set<bool>(SettingsRepositoryKeys.isBootstrapEnabled, value);
    _settings = _settings.copyWith(isBootstrapEnabled: value);
    _updatesStreamController.add(SettingsEvent(
      key: SettingsRepositoryKeys.isBootstrapEnabled,
      value: _settings,
    ));
  }

  Future<void> setIsBiometricsEnabled(final bool value) async {
    await _storage.set<bool>(SettingsRepositoryKeys.isBiometricsEnabled, value);
    _settings = _settings.copyWith(isBiometricsEnabled: value);
    _updatesStreamController.add(SettingsEvent(
      key: SettingsRepositoryKeys.isBiometricsEnabled,
      value: _settings,
    ));
  }
}
