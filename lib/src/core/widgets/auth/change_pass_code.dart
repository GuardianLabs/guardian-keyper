part of 'auth.dart';

Future<void> showChangePassCode({
  required final BuildContext context,
  required final OnConfirmed onConfirmed,
  required final String currentPassCode,
  required final OnVibrate onVibrate,
}) {
  final padding = _getPadding(context);
  return screenLock(
    context: context,
    canCancel: true,
    config: _screenLockConfig,
    keyPadConfig: _keyPadConfig,
    secretsConfig: _secretsConfig,
    correctString: currentPassCode,
    title: Padding(
      padding: padding,
      child: _currentPassCodeTitle,
    ),
    cancelButton: _cancelButton,
    onCancelled: Navigator.of(context).pop,
    onError: (_) {
      ScaffoldMessenger.of(context).showSnackBar(_wrongPassCodeSnackbar);
      onVibrate();
    },
    onUnlocked: () {
      Navigator.of(context).pop();
      final inputController = InputController();
      screenLockCreate(
        context: context,
        canCancel: true,
        digits: passCodeLength,
        config: _screenLockConfig,
        keyPadConfig: _keyPadConfig,
        secretsConfig: _secretsConfig,
        inputController: inputController,
        title: Padding(
          padding: padding,
          child: const Text('Please create your new passcode'),
        ),
        confirmTitle: Padding(
          padding: padding,
          child: const Text('Please repeate your new passcode'),
        ),
        cancelButton: _cancelButton,
        onCancelled: Navigator.of(context).pop,
        customizedButtonChild: _resetButton,
        customizedButtonTap: inputController.unsetConfirmed,
        onError: (_) {
          ScaffoldMessenger.of(context).showSnackBar(_wrongPassCodeSnackbar);
          onVibrate();
        },
        onConfirmed: (final String value) async {
          await onConfirmed(value);
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(buildSnackBar(
              text: 'Your login passcode was changed successfully!',
              duration: snackBarDuration,
              isFloating: true,
              isError: false,
            ));
            Navigator.of(context).pop();
          }
        },
      ).then((_) => inputController.dispose);
    },
  );
}
