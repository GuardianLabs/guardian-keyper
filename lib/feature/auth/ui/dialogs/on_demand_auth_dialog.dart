import 'package:get_it/get_it.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';

import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/feature/auth/data/auth_manager.dart';

import 'auth_dialog_mixin.dart';

class OnDemandAuthDialog {
  static Future<void> show(BuildContext context) async {
    final authManager = GetIt.I<AuthManager>();
    final void Function()? authBio = await authManager.getUseBiometrics()
        ? () async {
            if (await authManager.localAuthenticate()) {
              if (context.mounted) Navigator.of(context).pop();
            }
          }
        : null;
    if (context.mounted) {
      return screenLock(
        context: context,
        canCancel: false,
        config: AuthDialogBase.getScreenLockConfig(context),
        keyPadConfig: AuthDialogBase.keyPadConfig,
        secretsConfig: AuthDialogBase.secretsConfig,
        correctString: authManager.passCode,
        title: Padding(
          padding: AuthDialogBase.getPadding(context),
          child: AuthDialogBase.currentPassCodeTitle,
        ),
        customizedButtonChild:
            authBio == null ? null : const Icon(Icons.fingerprint, size: 48),
        customizedButtonTap: authBio,
        onOpened: authBio,
        onUnlocked: Navigator.of(context).pop,
        onError: (_) {
          ScaffoldMessenger.of(context).showSnackBar(buildSnackBar(
            context,
            text: 'Wrong passcode!',
            isFloating: true,
            isError: true,
          ));
          authManager.vibrate();
        },
      );
    }
  }
}
