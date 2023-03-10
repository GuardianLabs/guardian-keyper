import 'package:flutter_screen_lock/flutter_screen_lock.dart';

import '/src/core/widgets/common.dart';
import '/src/core/widgets/icon_of.dart';

import 'shared.dart';

Future<void> showCheckPassCode({
  required final BuildContext context,
  required final void Function() onUnlock,
  required final void Function()? checkBiometric,
  required final Duration snackBarDuration,
  required final String currentPassCode,
  required final bool canCancel,
}) =>
    screenLock(
      context: context,
      correctString: currentPassCode,
      canCancel: canCancel,
      cancelButton: cancelButton,
      keyPadConfig: keyPadConfig,
      secretsConfig: secretsConfig,
      config: screenLockConfig,
      title: Padding(
        padding: getPadding(MediaQuery.of(context).size.height),
        child: const Text('Please enter your current passcode'),
      ),
      customizedButtonChild: checkBiometric == null
          ? null
          : const IconOf.biometricLogon(bgColor: Colors.transparent, size: 48),
      customizedButtonTap: checkBiometric,
      onOpened: checkBiometric,
      onUnlocked: onUnlock,
      onError: (_) {
        ScaffoldMessenger.of(context).showSnackBar(buildSnackBar(
          text: 'Wrong passcode!',
          duration: snackBarDuration,
          isFloating: true,
          isError: true,
        ));
        vibrate();
      },
    );
