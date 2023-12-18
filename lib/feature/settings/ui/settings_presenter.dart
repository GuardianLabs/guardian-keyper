import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';

import 'package:guardian_keyper/consts.dart';
import 'package:guardian_keyper/ui/utils/theme_mode_mapper.dart';

import 'package:guardian_keyper/feature/auth/data/auth_manager.dart';
import 'package:guardian_keyper/feature/network/data/network_manager.dart';
import 'package:guardian_keyper/feature/settings/domain/use_case/settings_theme_case.dart';

export 'package:provider/provider.dart';

class SettingsPresenter extends ChangeNotifier with ThemeModeMapper {
  SettingsPresenter() {
    _authManager.getHasBiometrics().then((hasBiometrics) {
      if (hasBiometrics != _hasBiometrics) {
        _hasBiometrics = hasBiometrics;
        notifyListeners();
      }
    });
  }

  final _themeModeHandler = SettingsThemeCase();

  final _authManager = GetIt.I<AuthManager>();

  final _networkManager = GetIt.I<NetworkManager>();

  late String _deviceName = _networkManager.selfId.name;

  bool _hasBiometrics = false;

  bool get hasBiometrics => _hasBiometrics;

  String get deviceName => _networkManager.selfId.name;

  bool get isBiometricsEnabled => _authManager.isBiometricsEnabled;

  bool get isBootstrapEnabled => _networkManager.isBootstrapEnabled;

  bool get hasMinimumDeviceNameLength => _deviceName.length >= minNameLength;

  ThemeMode get selectedThemeMode =>
      mapBoolToThemeMode(_themeModeHandler.isDarkMode);

  set deviceName(String value) {
    _deviceName = value;
    notifyListeners();
  }

  Future<void> setDeviceName() async {
    if (_networkManager.selfId.name == _deviceName) return;
    await _networkManager.setDeviceName(_deviceName);
    notifyListeners();
  }

  Future<void> setBootstrap(bool isEnabled) async {
    await _networkManager.setBootstrap(isEnabled: isEnabled);
    notifyListeners();
  }

  Future<void> setBiometrics(bool isEnabled) async {
    await _authManager.setBiometrics(isEnabled: isEnabled);
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    await _themeModeHandler.setIsDarkMode(mapThemeModeToBool(themeMode));
    notifyListeners();
  }
}
