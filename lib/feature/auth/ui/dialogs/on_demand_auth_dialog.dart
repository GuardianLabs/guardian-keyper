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
        useBlur: true,
        config: AuthDialogMixin.getScreenLockConfig(context),
        keyPadConfig: AuthDialogMixin.keyPadConfig,
        correctString: authManager.passCode,
        title: Padding(
          padding: AuthDialogMixin.getPadding(context),
          child: AuthDialogMixin.currentPassCodeTitle,
        ),
        customizedButtonChild:
            authBio == null ? null : const Icon(Icons.fingerprint, size: 48),
        customizedButtonTap: authBio,
        onOpened: authBio,
        onUnlocked: Navigator.of(context).pop,
        onError: (_) {
          showSnackBar(
            context,
            text: 'Wrong passcode!',
            isFloating: true,
            isError: true,
          );
          authManager.vibrate();
        },
      );
    }
  }
}
