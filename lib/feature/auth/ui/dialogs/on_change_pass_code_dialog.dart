import 'package:get_it/get_it.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';

import 'package:guardian_keyper/consts.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/feature/auth/data/auth_manager.dart';

import 'auth_dialog_mixin.dart';

class OnChangePassCodeDialog {
  static Future<void> show(BuildContext context) {
    final authManager = GetIt.I<AuthManager>();
    final padding = AuthDialogMixin.getPadding(context);
    return screenLock(
      context: context,
      config: AuthDialogMixin.getScreenLockConfig(context),
      keyPadConfig: AuthDialogMixin.keyPadConfig,
      correctString: authManager.passCode,
      title: Padding(
        padding: padding,
        child: AuthDialogMixin.currentPassCodeTitle,
      ),
      cancelButton: AuthDialogMixin.cancelButton,
      onCancelled: Navigator.of(context).pop,
      onError: (_) {
        showSnackBar(
          context,
          text: 'Wrong passcode!',
          isFloating: true,
          isError: true,
        );
        authManager.vibrate();
      },
      onUnlocked: () {
        Navigator.of(context).pop();
        final inputController = InputController();
        screenLockCreate(
          context: context,
          digits: passCodeLength,
          config: AuthDialogMixin.getScreenLockConfig(context),
          keyPadConfig: AuthDialogMixin.keyPadConfig,
          inputController: inputController,
          title: Padding(
            padding: padding,
            child: const Text('Please create your new passcode'),
          ),
          confirmTitle: Padding(
            padding: padding,
            child: const Text('Please repeate your new passcode'),
          ),
          cancelButton: AuthDialogMixin.cancelButton,
          onCancelled: Navigator.of(context).pop,
          customizedButtonChild: AuthDialogMixin.resetButton,
          customizedButtonTap: inputController.unsetConfirmed,
          onError: (_) {
            showSnackBar(
              context,
              text: 'Wrong passcode!',
              isFloating: true,
              isError: true,
            );
            authManager.vibrate();
          },
          onConfirmed: (passCode) async {
            await authManager.setPassCode(passCode);
            if (context.mounted) {
              Navigator.of(context).pop();
              showSnackBar(
                context,
                text: 'Your login passcode was changed successfully!',
                isFloating: true,
              );
            }
          },
        ).then((_) => inputController.dispose);
      },
    );
  }
}
