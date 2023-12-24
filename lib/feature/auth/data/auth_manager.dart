import 'dart:async';

import 'package:get_it/get_it.dart';

import 'package:guardian_keyper/data/services/preferences_service.dart';

import 'package:guardian_keyper/feature/auth/data/auth_service.dart';

export 'package:get_it/get_it.dart';

typedef AuthManagerState = ({
  bool isBiometricsEnabled,
});

/// Depends on [PreferencesService]
class AuthManager {
  AuthManager({
    AuthService? authService,
    PreferencesService? prefService,
  })  : _authService = authService ?? AuthService(),
        _preferencesService = prefService ?? GetIt.I<PreferencesService>();

  final AuthService _authService;

  final PreferencesService _preferencesService;

  final _stateStreamController = StreamController<AuthManagerState>.broadcast();

  late final vibrate = _authService.vibrate;

  late String _passCode;

  late bool _hasBiometrics;

  late bool _isBiometricsEnabled;

  String get passCode => _passCode;

  bool get hasBiometrics => _hasBiometrics;

  bool get isBiometricsEnabled => _isBiometricsEnabled;

  Stream<AuthManagerState> get state => _stateStreamController.stream;

  Future<AuthManager> init() async {
    _hasBiometrics = await getHasBiometrics();
    _isBiometricsEnabled = await _preferencesService
            .get<bool>(PreferencesKeys.keyIsBiometricsEnabled) ??
        true;
    _passCode =
        await _preferencesService.get<String>(PreferencesKeys.keyPassCode) ??
            '';
    return this;
  }

  Future<void> dispose() async {
    await _stateStreamController.close();
  }

  Future<bool> getHasBiometrics() async =>
      _hasBiometrics = await _authService.getHasBiometrics();

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

  Future<void> setIsBiometricsEnabled(bool isEnabled) {
    _isBiometricsEnabled = isEnabled;
    _updateState();
    return _preferencesService.set<bool>(
      PreferencesKeys.keyIsBiometricsEnabled,
      isEnabled,
    );
  }

  void _updateState() =>
      _stateStreamController.add((isBiometricsEnabled: _isBiometricsEnabled));
}
