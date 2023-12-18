import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'package:guardian_keyper/feature/auth/data/auth_manager.dart';

import 'auth_dialog_mixin.dart';

class OnAskAuthDialog extends AuthDialogBase {
  static Future<void> show(
    BuildContext context, {
    required VoidCallback onUnlocked,
  }) async {
    final authManager = GetIt.I<AuthManager>();
    final void Function()? authBio = await authManager.getUseBiometrics()
        ? () async {
            if (await authManager.localAuthenticate()) {
              if (context.mounted) Navigator.of(context).pop();
              onUnlocked();
            }
          }
        : null;
    if (context.mounted) {
      return screenLock(
        context: context,
        config: AuthDialogBase.screenLockConfig,
        keyPadConfig: AuthDialogBase.keyPadConfig,
        secretsConfig: AuthDialogBase.secretsConfig,
        correctString: authManager.passCode,
        title: Padding(
          padding: AuthDialogBase.getPadding(context),
          child: AuthDialogBase.currentPassCodeTitle,
        ),
        cancelButton: AuthDialogBase.cancelButton,
        customizedButtonChild:
            authBio == null ? null : AuthDialogBase.biometricsIcon,
        customizedButtonTap: authBio,
        onOpened: authBio,
        onUnlocked: () {
          if (context.mounted) Navigator.of(context).pop();
          onUnlocked();
        },
        onError: (_) {
          authManager.vibrate();
          ScaffoldMessenger.of(context)
              .showSnackBar(AuthDialogBase.wrongPassCodeSnackbar);
        },
      );
    }
  }
}
