import 'package:get_it/get_it.dart';

import 'package:guardian_keyper/src/core/data/platform_manager.dart';

import '../data/settings_manager.dart';

class SettingsInteractor {
  String get passCode => _settingsManager.passCode;

  String get deviceName => _settingsManager.deviceName;

  bool get isBootstrapEnabled => _settingsManager.isBootstrapEnabled;

  bool get isBiometricsEnabled => _settingsManager.isBiometricsEnabled;

  bool get useBiometrics => hasBiometrics && isBiometricsEnabled;

  bool get hasBiometrics => _settingsManager.hasBiometrics;

  Stream<MapEntry<String, Object>> get settingsChanges =>
      _settingsManager.changes;

  late final vibrate = _platformManager.vibrate;

  late final setPassCode = _settingsManager.setPassCode;

  late final setDeviceName = _settingsManager.setDeviceName;

  late final setIsBootstrapEnabled = _settingsManager.setIsBootstrapEnabled;

  late final setIsBiometricsEnabled = _settingsManager.setIsBiometricsEnabled;

  final _settingsManager = GetIt.I<SettingsManager>();
  final _platformManager = GetIt.I<PlatformManager>();
}
