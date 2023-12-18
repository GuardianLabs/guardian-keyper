import 'package:get_it/get_it.dart';

import 'package:guardian_keyper/data/services/preferences_service.dart';

import 'auth_service.dart';

/// Depends on [PreferencesService]
class AuthManager {
  AuthManager({
    AuthService? authService,
  }) : _authService = authService ?? AuthService();

  final AuthService _authService;

  late final vibrate = _authService.vibrate;
  late final getHasBiometrics = _authService.getHasBiometrics;

  final _preferencesService = GetIt.I<PreferencesService>();

  late String _passCode;
  late bool _isBiometricsEnabled;

  String get passCode => _passCode;
  bool get isBiometricsEnabled => _isBiometricsEnabled;

  Future<AuthManager> init() async {
    _passCode =
        await _preferencesService.get<String>(PreferencesKeys.keyPassCode) ??
            '';
    _isBiometricsEnabled = await _preferencesService
            .get<bool>(PreferencesKeys.keyIsBiometricsEnabled) ??
        true;
    return this;
  }

  Future<bool> getUseBiometrics() async =>
      await getHasBiometrics() && isBiometricsEnabled;

  Future<bool> localAuthenticate({
    bool biometricOnly = true,
    String localizedReason = 'Please authenticate to log into the app',
  }) async {
    try {
      return await _authService.localAuthenticate(
        biometricOnly: biometricOnly,
        localizedReason: localizedReason,
      );
    } catch (_) {
      return false;
    }
  }

  Future<void> setPassCode(String value) {
    _passCode = value;
    return _preferencesService.set<String>(
      PreferencesKeys.keyPassCode,
      value,
    );
  }

  Future<void> setBiometrics({required bool isEnabled}) {
    _isBiometricsEnabled = isEnabled;
    return _preferencesService.set<bool>(
      PreferencesKeys.keyIsBiometricsEnabled,
      isEnabled,
    );
  }
}
