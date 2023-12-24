import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:flutter/widgets.dart';

import 'package:guardian_keyper/data/services/preferences_service.dart';

import 'package:guardian_keyper/feature/auth/data/auth_service.dart';

export 'package:get_it/get_it.dart';

typedef AuthManagerState = ({
  bool isBiometricsEnabled,
  bool hasBiometrics,
});

/// Depends on [PreferencesService]
class AuthManager with WidgetsBindingObserver {
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

  bool get useBiometrics => hasBiometrics && isBiometricsEnabled;

  Stream<AuthManagerState> get state => _stateStreamController.stream;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        _authService.getHasBiometrics().then((v) => _hasBiometrics = v);
      case AppLifecycleState.paused:
      case _:
    }
    _updateState();
  }

  Future<AuthManager> init() async {
    _hasBiometrics = await _authService.getHasBiometrics();
    _isBiometricsEnabled = await _preferencesService
            .get<bool>(PreferencesKeys.keyIsBiometricsEnabled) ??
        true;
    _passCode =
        await _preferencesService.get<String>(PreferencesKeys.keyPassCode) ??
            '';
    WidgetsBinding.instance.addObserver(this);
    return this;
  }

  Future<void> dispose() async {
    WidgetsBinding.instance.removeObserver(this);
    await _stateStreamController.close();
  }

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

  void _updateState() => _stateStreamController.add((
        isBiometricsEnabled: _isBiometricsEnabled,
        hasBiometrics: _hasBiometrics,
      ));
}
