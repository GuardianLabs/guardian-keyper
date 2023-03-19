part of 'auth.dart';

Future<void> showDemandPassCode({
  required final BuildContext context,
  required final String currentPassCode,
  required final LocalAuthenticate localAuthenticate,
  required final OnVibrate onVibrate,
  required final bool useBiometrics,
}) =>
    currentPassCode.isEmpty
        ? Future.value()
        : screenLock(
            context: context,
            canCancel: false,
            config: _screenLockConfig,
            keyPadConfig: _keyPadConfig,
            secretsConfig: _secretsConfig,
            correctString: currentPassCode,
            title: Padding(
              padding: _getPadding(context),
              child: _currentPassCodeTitle,
            ),
            customizedButtonChild: useBiometrics ? _biometricsIcon : null,
            customizedButtonTap: useBiometrics
                ? () async {
                    if (!await localAuthenticate()) return;
                    if (context.mounted) Navigator.of(context).pop();
                  }
                : null,
            onOpened: useBiometrics
                ? () async {
                    if (!await localAuthenticate()) return;
                    if (context.mounted) Navigator.of(context).pop();
                  }
                : null,
            onUnlocked: Navigator.of(context).pop,
            onError: (_) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(_wrongPassCodeSnackbar);
              onVibrate();
            },
          );
