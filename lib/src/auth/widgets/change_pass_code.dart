import 'package:flutter_screen_lock/flutter_screen_lock.dart';

import '/src/core/widgets/common.dart';
import '/src/core/widgets/icon_of.dart';

import 'shared.dart';

Future<void> showChangePassCode({
  required final BuildContext context,
  required final void Function() onExit,
  required final OnConfirmed onConfirmed,
  required final Duration snackBarDuration,
  required final String currentPassCode,
}) {
  final padding = getPadding(MediaQuery.of(context).size.height);
  return screenLock(
    context: context,
    correctString: currentPassCode,
    canCancel: true,
    secretsConfig: secretsConfig,
    keyPadConfig: keyPadConfig,
    config: screenLockConfig,
    title: Padding(
      padding: padding,
      child: const Text('Please enter your current passcode'),
    ),
    cancelButton: cancelButton,
    onCancelled: onExit,
    onError: (_) {
      ScaffoldMessenger.of(context).showSnackBar(buildSnackBar(
        text: 'Wrong passcode!',
        duration: snackBarDuration,
        isFloating: true,
        isError: true,
      ));
      vibrate();
    },
    onUnlocked: () => screenLockCreate(
      context: context,
      canCancel: true,
      digits: currentPassCode.length,
      keyPadConfig: keyPadConfig,
      secretsConfig: secretsConfig,
      config: screenLockConfig,
      title: Padding(
        padding: padding,
        child: const Text('Please create your new passcode'),
      ),
      confirmTitle: Padding(
        padding: padding,
        child: const Text('Please repeate your new passcode'),
      ),
      cancelButton: cancelButton,
      onCancelled: onExit,
      onError: (_) {
        ScaffoldMessenger.of(context).showSnackBar(buildSnackBar(
          text: 'Wrong passcode!',
          duration: snackBarDuration,
          isFloating: true,
          isError: true,
        ));
        vibrate();
      },
      onConfirmed: (value) async {
        await onConfirmed(value);
        if (context.mounted) {
          await showModalBottomSheet(
            context: context,
            isDismissible: true,
            isScrollControlled: false,
            builder: (final BuildContext context) => BottomSheetWidget(
              icon: const IconOf.secrets(isBig: true, bage: BageType.ok),
              titleString: 'Passcode changed',
              textString: 'Your login passcode was changed successfully.',
              footer: PrimaryButton(
                text: 'Done',
                onPressed: onExit,
              ),
            ),
          );
        }
      },
    ),
  );
}
