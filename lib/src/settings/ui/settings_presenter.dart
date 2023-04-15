import 'dart:async';
import 'package:flutter/widgets.dart';

import '../domain/settings_interactor.dart';

class SettingsPresenter extends ChangeNotifier {
  SettingsPresenter({
    SettingsInteractor? settingsInteractor,
  }) : _settingsInteractor = settingsInteractor ?? SettingsInteractor() {
    _updatesSubsrciption =
        _settingsInteractor.settingsChanges.listen((_) => notifyListeners());
  }

  String get passCode => _settingsInteractor.passCode;
  String get deviceName => _settingsInteractor.deviceName;
  bool get hasBiometrics => _settingsInteractor.hasBiometrics;
  bool get isBootstrapEnabled => _settingsInteractor.isBootstrapEnabled;
  bool get isBiometricsEnabled => _settingsInteractor.isBiometricsEnabled;

  late final vibrate = _settingsInteractor.vibrate;
  late final setPassCode = _settingsInteractor.setPassCode;
  late final setDeviceName = _settingsInteractor.setDeviceName;
  late final setIsBootstrapEnabled = _settingsInteractor.setIsBootstrapEnabled;
  late final setIsBiometricsEnabled =
      _settingsInteractor.setIsBiometricsEnabled;

  final SettingsInteractor _settingsInteractor;

  late final StreamSubscription<void> _updatesSubsrciption;

  @override
  void dispose() async {
    await _updatesSubsrciption.cancel();
    super.dispose();
  }
}
