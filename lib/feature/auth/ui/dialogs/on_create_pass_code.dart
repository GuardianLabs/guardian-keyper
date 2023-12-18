import 'package:get_it/get_it.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';

import 'package:guardian_keyper/consts.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/feature/auth/data/auth_manager.dart';

import 'auth_dialog_mixin.dart';

class OnCreatePassCodeDialog {
  static Future<void> show(BuildContext context) {
    final authManager = GetIt.I<AuthManager>();
    final inputController = InputController();
    final padding = AuthDialogBase.getPadding(context);
    return screenLockCreate(
      context: context,
      canCancel: false,
      digits: passCodeLength,
      config: AuthDialogBase.getScreenLockConfig(context),
      keyPadConfig: AuthDialogBase.keyPadConfig,
      secretsConfig: AuthDialogBase.secretsConfig,
      inputController: inputController,
      title: Padding(
        padding: padding,
        child: const Text('Create your passcode'),
      ),
      confirmTitle: Padding(
        padding: padding,
        child: const Text('Enter it once more'),
      ),
      customizedButtonChild: AuthDialogBase.resetButton,
      customizedButtonTap: inputController.unsetConfirmed,
      onConfirmed: (passCode) async {
        await authManager.setPassCode(passCode);
        if (context.mounted) Navigator.of(context).pop();
      },
      onError: (_) {
        ScaffoldMessenger.of(context).showSnackBar(buildSnackBar(
          context,
          text: 'Wrong passcode!',
          isFloating: true,
          isError: true,
        ));
        authManager.vibrate();
      },
    ).then((_) => inputController.dispose);
  }
}
