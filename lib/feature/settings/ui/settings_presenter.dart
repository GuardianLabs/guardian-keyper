import 'package:get_it/get_it.dart';
import 'package:flutter/widgets.dart';

import '../domain/settings_interactor.dart';

export 'package:provider/provider.dart';

class SettingsPresenter extends ChangeNotifier {
  SettingsPresenter() {
    _updatesSubsrciption.resume();
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

  @override
  void dispose() {
    _updatesSubsrciption.cancel();
    super.dispose();
  }

  // Private
  final _settingsInteractor = GetIt.I<SettingsInteractor>();

  late final _updatesSubsrciption = _settingsInteractor.settingsChanges.listen(
    (_) => notifyListeners(),
  );
}
