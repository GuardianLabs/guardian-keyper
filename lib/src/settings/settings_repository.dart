import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/src/core/service/service_root.dart';
import '/src/core/storage/flutter_secure_storage.dart';

import 'settings_model.dart';

enum SettingsKeys {
  seed,
  passCode,
  deviceName,
  isBootstrapEnabled,
  isBiometricsEnabled,
}

class SettingsRepository extends Cubit<SettingsModel> {
  SettingsRepository({
    SecureStorage? storageService,
    ServiceRoot? serviceRoot,
  })  : _storage =
            storageService ?? FlutterSecureStorage(storage: Storages.settings),
        _serviceRoot = serviceRoot ?? GetIt.I<ServiceRoot>(),
        super(const SettingsModel());

  final SecureStorage _storage;
  final ServiceRoot _serviceRoot;

  Future<void> load() async {
    emit(SettingsModel(
      passCode: await _storage.getOr<String>(SettingsKeys.passCode, ''),
      hasBiometrics: await _serviceRoot.platformService.getHasBiometrics(),
      deviceName: await _storage.getOr<String>(
        SettingsKeys.deviceName,
        await _serviceRoot.platformService
            .getDeviceName(maxNameLength: SettingsModel.maxNameLength),
      ),
      isBootstrapEnabled: await _storage.getOr<bool>(
        SettingsKeys.isBootstrapEnabled,
        true,
      ),
      isBiometricsEnabled: await _storage.getOr<bool>(
        SettingsKeys.isBiometricsEnabled,
        true,
      ),
    ));
  }

  Future<String> setDeviceName(final String value) async {
    await _storage.set<String>(SettingsKeys.deviceName, value);
    emit(state.copyWith(deviceName: value));
    return value;
  }

  Future<String> setPassCode(final String value) async {
    await _storage.set<String>(SettingsKeys.passCode, value);
    emit(state.copyWith(passCode: value));
    return value;
  }

  Future<bool> setIsBiometricsEnabled(final bool value) async {
    await _storage.set<bool>(SettingsKeys.isBiometricsEnabled, value);
    emit(state.copyWith(isBiometricsEnabled: value));
    return value;
  }

  Future<bool> setIsBootstrapEnabled(final bool value) async {
    await _storage.set<bool>(SettingsKeys.isBootstrapEnabled, value);
    emit(state.copyWith(isBootstrapEnabled: value));
    return value;
  }
}
