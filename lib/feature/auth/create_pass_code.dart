part of '../../../../feature/auth/auth.dart';

Future<void> showCreatePassCode({
  required BuildContext context,
  required final OnConfirmed onConfirmed,
  required final Future<void> Function() onVibrate,
}) {
  final inputController = InputController();
  final padding = _getPadding(context);
  return screenLockCreate(
    context: context,
    canCancel: false,
    digits: passCodeLength,
    config: _screenLockConfig,
    keyPadConfig: _keyPadConfig,
    secretsConfig: _secretsConfig,
    inputController: inputController,
    title: Padding(
      padding: padding,
      child: const Text('Create your passcode'),
    ),
    confirmTitle: Padding(
      padding: padding,
      child: const Text('Enter it once more'),
    ),
    customizedButtonChild: _resetButton,
    customizedButtonTap: inputController.unsetConfirmed,
    onConfirmed: (final String passCode) async {
      Navigator.of(context).pop();
      await onConfirmed(passCode);
    },
    onError: (_) {
      ScaffoldMessenger.of(context).showSnackBar(_wrongPassCodeSnackbar);
      onVibrate();
    },
  ).then((_) => inputController.dispose);
}
