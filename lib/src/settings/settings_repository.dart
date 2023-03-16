import 'dart:async';
import 'dart:typed_data';
import 'package:get_it/get_it.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/src/core/service/service_root.dart';
import '/src/core/storage/flutter_secure_storage.dart';

import 'settings_model.dart';

export 'settings_model.dart';

class SettingsRepository extends Cubit<SettingsModel> {
  static const _keySeed = 'seed';
  static const _keyPassCode = 'pass_code';
  static const _keyDeviceName = 'device_name';
  static const _keyIsBootstrapEnabled = 'is_bootstrap_enabled';
  static const _keyIsBiometricsEnabled = 'is_biometrics_enabled';

  SettingsRepository({SecureStorage? storageService})
      : _storage =
            storageService ?? FlutterSecureStorage(storageName: 'settings'),
        super(const SettingsModel());

  final SecureStorage _storage;

  final _streamController = StreamController<SettingsModel>.broadcast();

  Stream<SettingsModel> get streamChanges => _streamController.stream;

  Future<void> init() async {
    final platformService = GetIt.I<ServiceRoot>().platformService;
    var deviceName = await _storage.getOr<String>(_keyDeviceName, '');
    if (deviceName.isEmpty) {
      deviceName = await platformService.getDeviceName(
        maxNameLength: SettingsModel.maxNameLength,
      );
    }
    _streamController.add(SettingsModel(
      deviceName: deviceName,
      passCode: await _storage.getOr<String>(_keyPassCode, ''),
      hasBiometrics: await platformService.getHasBiometrics(),
      isBootstrapEnabled:
          await _storage.getOr<bool>(_keyIsBootstrapEnabled, true),
      isBiometricsEnabled:
          await _storage.getOr<bool>(_keyIsBiometricsEnabled, true),
    ));
  }

  Future<Uint8List> getSeed() =>
      _storage.getOr<Uint8List>(_keySeed, Uint8List(0));

  Future<Uint8List> setSeed(final Uint8List value) async {
    await _storage.set<Uint8List>(_keySeed, value);
    return value;
  }

  Future<String> setDeviceName(final String value) async {
    await _storage.set<String>(_keyDeviceName, value);
    _streamController.add(state.copyWith(deviceName: value));
    return value;
  }

  Future<String> setPassCode(final String value) async {
    await _storage.set<String>(_keyPassCode, value);
    _streamController.add(state.copyWith(passCode: value));
    return value;
  }

  Future<bool> setIsBiometricsEnabled(final bool value) async {
    await _storage.set<bool>(_keyIsBiometricsEnabled, value);
    _streamController.add(state.copyWith(isBiometricsEnabled: value));
    return value;
  }

  Future<bool> setIsBootstrapEnabled(final bool value) async {
    await _storage.set<bool>(_keyIsBootstrapEnabled, value);
    _streamController.add(state.copyWith(isBootstrapEnabled: value));
    return value;
  }
}
