import 'package:flutter/widgets.dart';

import '/src/core/repository/repository.dart';
import '/src/core/service/platform_service.dart';

import 'pages/auth.dart' as pages;

class AuthCase {
  final _platformService = GetIt.I<PlatformService>();
  final _settingsRepository = GetIt.I<SettingsRepository>();

  Future<void> createPassCode({
    required final BuildContext context,
    required final void Function() onConfirmed,
    required final void Function() onConfirmedHasBiometrics,
  }) =>
      pages.createPassCode(
        context: context,
        onVibrate: _platformService.vibrate,
        onConfirmed: (final String passCode) async {
          await _settingsRepository.setPassCode(passCode);
          _settingsRepository.state.hasBiometrics
              ? onConfirmedHasBiometrics()
              : onConfirmed();
        },
      );

  Future<void> logIn(final BuildContext context) => pages.logIn(
        context: context,
        onVibrate: _platformService.vibrate,
        currentPassCode: _settingsRepository.state.passCode,
        localAuthenticate: _platformService.localAuthenticate,
        useBiometrics: _settingsRepository.state.hasBiometrics &&
            _settingsRepository.state.isBiometricsEnabled,
      );

  Future<void> checkPassCode({
    required final BuildContext context,
    required final void Function() onUnlocked,
  }) =>
      pages.checkPassCode(
        context: context,
        onUnlocked: onUnlocked,
        onVibrate: _platformService.vibrate,
        currentPassCode: _settingsRepository.state.passCode,
        localAuthenticate: _platformService.localAuthenticate,
        useBiometrics: _settingsRepository.state.hasBiometrics &&
            _settingsRepository.state.isBiometricsEnabled,
      );

  Future<void> changePassCode({required final BuildContext context}) =>
      pages.changePassCode(
        context: context,
        onVibrate: _platformService.vibrate,
        onConfirmed: _settingsRepository.setPassCode,
        currentPassCode: _settingsRepository.state.passCode,
      );
}
