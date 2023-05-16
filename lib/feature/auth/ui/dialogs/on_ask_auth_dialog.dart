import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../domain/auth_interactor.dart';
import 'auth_dialog_mixin.dart';

class OnAskAuthDialog extends AuthDialogBase {
  static Future<void> show(
    BuildContext context, {
    required void Function() onUnlocked,
  }) {
    final authInteractor = GetIt.I<AuthInteractor>();
    if (authInteractor.passCode.isEmpty) return Future.value();

    void authBio() async {
      if (await authInteractor.localAuthenticate()) {
        if (context.mounted) Navigator.of(context).pop();
        onUnlocked();
      }
    }

    return screenLock(
      context: context,
      canCancel: true,
      config: AuthDialogBase.screenLockConfig,
      keyPadConfig: AuthDialogBase.keyPadConfig,
      secretsConfig: AuthDialogBase.secretsConfig,
      correctString: authInteractor.passCode,
      title: Padding(
        padding: AuthDialogBase.getPadding(context),
        child: AuthDialogBase.currentPassCodeTitle,
      ),
      cancelButton: AuthDialogBase.cancelButton,
      customizedButtonChild:
          authInteractor.useBiometrics ? AuthDialogBase.biometricsIcon : null,
      customizedButtonTap: authInteractor.useBiometrics ? authBio : null,
      onOpened: authInteractor.useBiometrics ? authBio : null,
      onUnlocked: () {
        if (context.mounted) Navigator.of(context).pop();
        onUnlocked();
      },
      onError: (_) {
        ScaffoldMessenger.of(context)
            .showSnackBar(AuthDialogBase.wrongPassCodeSnackbar);
        authInteractor.vibrate();
      },
    );
  }
}
