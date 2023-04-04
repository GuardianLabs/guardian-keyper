import 'dart:async';

import '/src/core/data/core_model.dart';
import '/src/core/service/service_root.dart';
import '/src/core/storage/flutter_secure_storage.dart';

enum SettingsRepositoryKeys {
  seed,
  passCode,
  deviceName,
  isBootstrapEnabled,
  isBiometricsEnabled,
}

class SettingsRepository {
  SettingsRepository({
    SecureStorage? storageService,
    ServiceRoot? serviceRoot,
  })  : _storage =
            storageService ?? FlutterSecureStorage(storage: Storages.settings),
        _serviceRoot = serviceRoot ?? GetIt.I<ServiceRoot>();

  String get passCode => _passCode;
  String get deviceName => _deviceName;
  bool get hasBiometrics => _hasBiometrics;
  bool get isBootstrapEnabled => _isBootstrapEnabled;
  bool get isBiometricsEnabled => _isBiometricsEnabled;
  Stream<MapEntry> get stream => _updatesNotifier.stream;

  final SecureStorage _storage;
  final ServiceRoot _serviceRoot;

  final _updatesNotifier = StreamController<MapEntry>.broadcast();

  late bool _isBiometricsEnabled, _isBootstrapEnabled, _hasBiometrics;
  late String _passCode, _deviceName;

  Future<void> load() async {
    _hasBiometrics = await _serviceRoot.platformService.getHasBiometrics();
    _deviceName = await _storage.getOr<String>(
      SettingsRepositoryKeys.deviceName,
      await _serviceRoot.platformService
          .getDeviceName(maxNameLength: IdBase.maxNameLength),
    );
    _passCode = await _storage.getOr<String>(
      SettingsRepositoryKeys.passCode,
      '',
    );
    _isBootstrapEnabled = await _storage.getOr<bool>(
      SettingsRepositoryKeys.isBootstrapEnabled,
      true,
    );
    _isBiometricsEnabled = await _storage.getOr<bool>(
      SettingsRepositoryKeys.isBiometricsEnabled,
      true,
    );
  }

  Future<String> setDeviceName(final String value) async {
    _deviceName = (await _storage.set<String>(
      SettingsRepositoryKeys.deviceName,
      value,
    ))!;
    _updatesNotifier.add(MapEntry(
      SettingsRepositoryKeys.deviceName,
      value,
    ));
    return _deviceName;
  }

  Future<String> setPassCode(final String value) async {
    _passCode = (await _storage.set<String>(
      SettingsRepositoryKeys.passCode,
      value,
    ))!;
    _updatesNotifier.add(MapEntry(
      SettingsRepositoryKeys.passCode,
      value,
    ));
    return _passCode;
  }

  Future<bool> setIsBiometricsEnabled(final bool value) async {
    _isBiometricsEnabled = (await _storage.set<bool>(
      SettingsRepositoryKeys.isBiometricsEnabled,
      value,
    ))!;
    _updatesNotifier.add(MapEntry(
      SettingsRepositoryKeys.isBiometricsEnabled,
      value,
    ));
    return _isBiometricsEnabled;
  }

  Future<bool> setIsBootstrapEnabled(final bool value) async {
    _isBootstrapEnabled = (await _storage.set<bool>(
      SettingsRepositoryKeys.isBootstrapEnabled,
      value,
    ))!;
    _updatesNotifier.add(MapEntry(
      SettingsRepositoryKeys.isBootstrapEnabled,
      value,
    ));
    return _isBootstrapEnabled;
  }
}
