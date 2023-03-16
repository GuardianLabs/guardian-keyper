import 'dart:async';
import 'dart:typed_data';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/src/core/service/service.dart';

import 'settings_model.dart';

export 'package:get_it/get_it.dart';
export 'package:flutter_bloc/flutter_bloc.dart';

export 'settings_model.dart';

class SettingsRepository extends Cubit<SettingsModel> {
  static const _keySeed = 'seed';
  static const _keyPassCode = 'pass_code';
  static const _keyDeviceName = 'device_name';
  static const _keyIsBootstrapEnabled = 'is_bootstrap_enabled';
  static const _keyIsBiometricsEnabled = 'is_biometrics_enabled';

  SettingsRepository({StorageService? storageService})
      : _storage = storageService ??
            FlutterSecureStorageService(storageName: 'settings'),
        super(const SettingsModel());

  final StorageService _storage;

  late final Uint8List _seed; // TBD: move seed out here

  Uint8List get seed => _seed; // TBD: move seed out here

  Future<void> init() async {
    // TBD: move seed out here
    _seed = await _storage.getOr<Uint8List>(_keySeed, Uint8List(0));
    final platformService = GetIt.I<PlatformService>();
    var deviceName = await _storage.getOr<String>(_keyDeviceName, '');
    if (deviceName.isEmpty) {
      deviceName = await platformService.getDeviceName(
        maxNameLength: SettingsModel.maxNameLength,
      );
    }
    emit(SettingsModel(
      deviceName: deviceName,
      passCode: await _storage.getOr<String>(_keyPassCode, ''),
      hasBiometrics: await platformService.getHasBiometrics(),
      isBootstrapEnabled: await _storage.getOr<bool>(
        _keyIsBootstrapEnabled,
        true,
      ),
      isBiometricsEnabled: await _storage.getOr<bool>(
        _keyIsBiometricsEnabled,
        true,
      ),
    ));
  }

  // TBD: move out here
  Future<Uint8List> setSeedKey(final Uint8List value) async {
    if (_seed.isEmpty) await _storage.set<Uint8List>(_keySeed, value);
    return value;
  }

  Future<String> setDeviceName(final String value) async {
    await _storage.set<String>(_keyDeviceName, value);
    emit(state.copyWith(deviceName: value));
    return value;
  }

  Future<String> setPassCode(final String value) async {
    await _storage.set<String>(_keyPassCode, value);
    emit(state.copyWith(passCode: value));
    return value;
  }

  Future<bool> setIsBiometricsEnabled(final bool value) async {
    await _storage.set<bool>(_keyIsBiometricsEnabled, value);
    emit(state.copyWith(isBiometricsEnabled: value));
    return value;
  }

  Future<bool> setIsBootstrapEnabled(final bool value) async {
    await _storage.set<bool>(_keyIsBootstrapEnabled, value);
    emit(state.copyWith(isBootstrapEnabled: value));
    return value;
  }
}
