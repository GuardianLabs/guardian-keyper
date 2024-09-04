import 'dart:async';

import 'package:flutter/material.dart';
import 'package:guardian_keyper/ui/presenters/name_helper_mixin.dart';
import 'package:guardian_keyper/domain/entity/peer_id.dart';
import 'package:guardian_keyper/data/managers/network_manager.dart';
import 'package:guardian_keyper/data/services/platform_service.dart';

import 'package:guardian_keyper/data/repositories/settings_repository.dart';

export 'package:provider/provider.dart';

class SettingsPresenter with ChangeNotifier, NameHelperMixin {
  SettingsPresenter() {
    _settingsChanges.resume();
    name = _settingsRepository.get<String>(PreferencesKeys.keyDeviceName, '')!;
    if (name.isEmpty) {
      _platformService.getDeviceName().then(
        (value) {
          name = value;
          notifyListeners();
        },
      );
    }
    unawaited(onResumed());
  }

  final _networkManager = GetIt.I<NetworkManager>();
  final _platformService = GetIt.I<PlatformService>();
  final _settingsRepository = GetIt.I<SettingsRepository>();

  late final _settingsChanges =
      _settingsRepository.watch().listen((_) => notifyListeners());

  bool _hasBiometrics = false;

  PeerId get selfId => _networkManager.selfId;

  bool get isFirstStart => passCode.isEmpty;

  bool get hasBiometrics => _hasBiometrics;

  bool get useBiometrics => hasBiometrics && isBiometricsEnabled;

  String get passCode => _settingsRepository.get<String>(
        PreferencesKeys.keyPassCode,
        '',
      )!;

  bool get isBiometricsEnabled => _settingsRepository.get<bool>(
        PreferencesKeys.keyIsBiometricsEnabled,
        false,
      )!;

  bool get isBootstrapEnabled => _settingsRepository.get<bool>(
        PreferencesKeys.keyIsBootstrapEnabled,
        true,
      )!;

  ThemeMode get themeMode => switch (_settingsRepository.get<bool>(
        PreferencesKeys.keyIsDarkModeOn,
      )) {
        true => ThemeMode.dark,
        false => ThemeMode.light,
        null => ThemeMode.system,
      };

  @override
  void dispose() {
    _settingsChanges.cancel();
    super.dispose();
  }

  Future<void> onResumed() async {
    if (_hasBiometrics == await _platformService.getHasBiometrics()) return;
    _hasBiometrics = !_hasBiometrics;
    notifyListeners();
  }

  Future<void> setIsThemeMode(ThemeMode value) =>
      _settingsRepository.setNullable<bool>(
        PreferencesKeys.keyIsDarkModeOn,
        switch (value) {
          ThemeMode.dark => true,
          ThemeMode.light => false,
          ThemeMode.system => null,
        },
      );

  Future<void> setIsBootstrapEnabled(bool value) =>
      _settingsRepository.set<bool>(
        PreferencesKeys.keyIsBootstrapEnabled,
        value,
      );

  Future<void> setIsBiometricsEnabled(bool value) =>
      _settingsRepository.set<bool>(
        PreferencesKeys.keyIsBiometricsEnabled,
        value,
      );

  Future<void> setDeviceName([String? value]) async {
    name = value ?? name;
    await _settingsRepository.set<String>(
      PreferencesKeys.keyDeviceName,
      name,
    );
    notifyListeners();
  }

  Future<void> setPassCode(String value) => _settingsRepository.set<String>(
        PreferencesKeys.keyPassCode,
        value,
      );

  Future<void> vibrate() => _platformService.vibrate();

  Future<bool> localAuthenticate({
    bool biometricOnly = true,
    String localizedReason = 'Please authenticate to log into the app',
  }) async {
    try {
      return await _platformService.localAuthenticate(
        biometricOnly: biometricOnly,
        localizedReason: localizedReason,
      );
    } catch (_) {
      return false;
    }
  }

  Future<bool> getUseBiometrics() async {
    _hasBiometrics = await _platformService.getHasBiometrics();
    return useBiometrics;
  }

  Future<void> clearSettings() async {
    await setPassCode('');
    await setDeviceName('');
    await setIsBiometricsEnabled(false);
  }
}
