import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../domain/auth_interactor.dart';
import 'auth_dialog_mixin.dart';

class OnDemandAuthDialog {
  static Future<void> show(BuildContext context) {
    final authInteractor = GetIt.I<AuthInteractor>();
    return screenLock(
      context: context,
      canCancel: false,
      config: AuthDialogBase.screenLockConfig,
      keyPadConfig: AuthDialogBase.keyPadConfig,
      secretsConfig: AuthDialogBase.secretsConfig,
      correctString: authInteractor.passCode,
      title: Padding(
        padding: AuthDialogBase.getPadding(context),
        child: AuthDialogBase.currentPassCodeTitle,
      ),
      customizedButtonChild:
          authInteractor.useBiometrics ? AuthDialogBase.biometricsIcon : null,
      customizedButtonTap: authInteractor.useBiometrics
          ? () async {
              if (!await authInteractor.localAuthenticate()) return;
              if (context.mounted) Navigator.of(context).pop();
            }
          : null,
      onOpened: authInteractor.useBiometrics
          ? () async {
              if (!await authInteractor.localAuthenticate()) return;
              if (context.mounted) Navigator.of(context).pop();
            }
          : null,
      onUnlocked: Navigator.of(context).pop,
      onError: (_) {
        ScaffoldMessenger.of(context)
            .showSnackBar(AuthDialogBase.wrongPassCodeSnackbar);
        authInteractor.vibrate();
      },
    );
  }
}
