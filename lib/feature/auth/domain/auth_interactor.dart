import 'package:get_it/get_it.dart';

import 'package:guardian_keyper/data/platform_service.dart';
import 'package:guardian_keyper/feature/settings/data/settings_manager.dart';

class AuthInteractor {
  late final vibrate = _platformManager.vibrate;
  late final localAuthenticate = _platformManager.localAuthenticate;

  late final setPassCode = _settingsManager.setPassCode;

  bool get useBiometrics =>
      _settingsManager.hasBiometrics && _settingsManager.isBiometricsEnabled;

  String get passCode => _settingsManager.passCode;

  final _platformManager = GetIt.I<PlatformService>();
  final _settingsManager = GetIt.I<SettingsManager>();
}
