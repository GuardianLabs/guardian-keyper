import 'package:flutter_screen_lock/flutter_screen_lock.dart';

import '/src/core/widgets/common.dart';

import 'shared.dart';

Future<void> showCreatePassCode({
  required final BuildContext context,
  required final OnConfirmed onConfirmed,
  required final Duration snackBarDuration,
  required final int passCodeLength,
}) {
  final height = MediaQuery.of(context).size.height;
  final inputController = InputController();
  return screenLockCreate(
    context: context,
    canCancel: false,
    digits: passCodeLength,
    keyPadConfig: keyPadConfig,
    secretsConfig: secretsConfig,
    config: screenLockConfig,
    inputController: inputController,
    title: Padding(
      padding: getPadding(height),
      child: const Text('Create your passcode'),
    ),
    confirmTitle: Padding(
      padding: getPadding(height),
      child: const Text('Enter it once more'),
    ),
    cancelButton: cancelButton,
    customizedButtonChild: const Text(
      'Reset',
      maxLines: 1,
      softWrap: false,
      textAlign: TextAlign.center,
      overflow: TextOverflow.visible,
    ),
    customizedButtonTap: inputController.unsetConfirmed,
    onConfirmed: onConfirmed,
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
}
