part of 'auth.dart';

Future<void> checkPassCode({
  required final BuildContext context,
  required final void Function() onUnlocked,
  required final LocalAuthenticate localAuthenticate,
  required final String currentPassCode,
  required final OnVibrate onVibrate,
  required final bool useBiometrics,
}) =>
    screenLock(
      context: context,
      canCancel: true,
      config: _screenLockConfig,
      keyPadConfig: _keyPadConfig,
      secretsConfig: _secretsConfig,
      correctString: currentPassCode,
      title: Padding(
        padding: _getPadding(context),
        child: _currentPassCodeTitle,
      ),
      cancelButton: _cancelButton,
      customizedButtonChild: useBiometrics ? _biometricsIcon : null,
      customizedButtonTap: useBiometrics
          ? () async {
              if (!await localAuthenticate()) return;
              if (context.mounted) Navigator.of(context).pop();
              onUnlocked();
            }
          : null,
      onOpened: useBiometrics
          ? () async {
              if (!await localAuthenticate()) return;
              if (context.mounted) Navigator.of(context).pop();
              onUnlocked();
            }
          : null,
      onUnlocked: onUnlocked,
      onError: (_) {
        ScaffoldMessenger.of(context).showSnackBar(_wrongPassCodeSnackbar);
        onVibrate();
      },
    );
