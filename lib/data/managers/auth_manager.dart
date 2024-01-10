import 'dart:async';

import '../services/auth_service.dart';
import '../repositories/settings_repository.dart';

export 'package:get_it/get_it.dart';

typedef AuthManagerState = ({
  bool isBiometricsEnabled,
  bool hasBiometrics,
});

/// Depends on [SettingsRepository]
class AuthManager {
  AuthManager({AuthService? authService})
      : _authService = authService ?? AuthService();

  final AuthService _authService;

  final _settingsRepository = GetIt.I<SettingsRepository>();

  final _stateStreamController = StreamController<AuthManagerState>.broadcast();

  DateTime _lastPausedAt = DateTime.now();

  late bool _hasBiometrics;

  late String _passCode =
      _settingsRepository.get<String>(PreferencesKeys.keyPassCode) ?? '';

  late bool _isBiometricsEnabled =
      _settingsRepository.get<bool>(PreferencesKeys.keyIsBiometricsEnabled) ??
          true;

  String get passCode => _passCode;

  bool get hasBiometrics => _hasBiometrics;

  bool get isBiometricsEnabled => _isBiometricsEnabled;

  bool get useBiometrics => hasBiometrics && isBiometricsEnabled;

  bool get needPasscode => _lastPausedAt
      .isBefore(DateTime.now().subtract(const Duration(seconds: 30)));

  Stream<AuthManagerState> get state => _stateStreamController.stream;

  Future<AuthManager> init() async {
    _hasBiometrics = await _authService.getHasBiometrics();
    return this;
  }

  Future<void> close() async {
    await _stateStreamController.close();
  }

  Future<void> onResumed() async {
    _hasBiometrics = await _authService.getHasBiometrics();
    _updateState();
  }

  Future<void> onInactive() async => _lastPausedAt = DateTime.now();

  Future<void> vibrate() => _authService.vibrate();

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
    return _settingsRepository.set<String>(
      PreferencesKeys.keyPassCode,
      value,
    );
  }

  Future<void> setIsBiometricsEnabled(bool isEnabled) {
    _isBiometricsEnabled = isEnabled;
    _updateState();
    return _settingsRepository.set<bool>(
      PreferencesKeys.keyIsBiometricsEnabled,
      isEnabled,
    );
  }

  void _updateState() => _stateStreamController.add((
        isBiometricsEnabled: _isBiometricsEnabled,
        hasBiometrics: _hasBiometrics,
      ));
}
