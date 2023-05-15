part of '../../../../feature/auth/auth.dart';

Future<void> showAskPassCode({
  required BuildContext context,
  required final String currentPassCode,
  required final void Function() onUnlocked,
  required final Future<void> Function() onVibrate,
  required final LocalAuthenticate localAuthenticate,
  required final bool useBiometrics,
}) =>
    currentPassCode.isEmpty
        ? Future.value()
        : screenLock(
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
            onUnlocked: () {
              if (context.mounted) Navigator.of(context).pop();
              onUnlocked();
            },
            onError: (_) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(_wrongPassCodeSnackbar);
              onVibrate();
            },
          );
