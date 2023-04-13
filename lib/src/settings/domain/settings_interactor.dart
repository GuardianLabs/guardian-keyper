import 'package:get_it/get_it.dart';

import '/src/core/data/platform_manager.dart';

import '../data/settings_repository.dart';

class SettingsInteractor {
  SettingsInteractor({
    PlatformManager? platformManager,
    SettingsRepository? settingsRepository,
  })  : _platformManager = platformManager ?? GetIt.I<PlatformManager>(),
        _settingsRepository =
            settingsRepository ?? GetIt.I<SettingsRepository>();

  bool get hasBiometrics => _platformManager.hasBiometrics;

  String get passCode => _settingsRepository.settings.passCode;

  String get deviceName => _settingsRepository.settings.deviceName;

  bool get isBootstrapEnabled =>
      _settingsRepository.settings.isBootstrapEnabled;

  bool get isBiometricsEnabled =>
      _settingsRepository.settings.isBiometricsEnabled;

  Stream<SettingsEvent> get settingsChanges => _settingsRepository.stream;

  late final vibrate = _platformManager.vibrate;

  late final setPassCode = _settingsRepository.setPassCode;

  late final setDeviceName = _settingsRepository.setDeviceName;

  late final setIsBootstrapEnabled = _settingsRepository.setIsBootstrapEnabled;

  late final setIsBiometricsEnabled =
      _settingsRepository.setIsBiometricsEnabled;

  final PlatformManager _platformManager;

  final SettingsRepository _settingsRepository;
}
