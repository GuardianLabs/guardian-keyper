import 'package:get_it/get_it.dart';
import 'package:flutter/widgets.dart';

import 'package:guardian_keyper/consts.dart';

import '../domain/settings_interactor.dart';

export 'package:provider/provider.dart';

class SettingsPresenter extends ChangeNotifier {
  String get passCode => _settingsInteractor.passCode;
  String get deviceName => _settingsInteractor.deviceName;
  bool get hasBiometrics => _settingsInteractor.hasBiometrics;
  bool get isBootstrapEnabled => _settingsInteractor.isBootstrapEnabled;
  bool get isBiometricsEnabled => _settingsInteractor.isBiometricsEnabled;
  bool get hasMinimumDeviceNameLength => _deviceName.length >= minNameLength;

  set deviceName(final String value) {
    _deviceName = value;
    notifyListeners();
  }

  Future<void> setDeviceName() async {
    if (_settingsInteractor.deviceName == _deviceName) return;
    await _settingsInteractor.setDeviceName(_deviceName);
    notifyListeners();
  }

  Future<void> setIsBootstrapEnabled(final bool value) async {
    await _settingsInteractor.setIsBootstrapEnabled(value);
    notifyListeners();
  }

  Future<void> setIsBiometricsEnabled(final bool value) async {
    await _settingsInteractor.setIsBiometricsEnabled(value);
    notifyListeners();
  }

  // Private
  final _settingsInteractor = GetIt.I<SettingsInteractor>();

  late String _deviceName = _settingsInteractor.deviceName;
}
