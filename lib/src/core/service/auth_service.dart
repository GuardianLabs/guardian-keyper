import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:local_auth/local_auth.dart';
import 'package:vibration/vibration.dart';

import '/src/core/di_container.dart';
import '/src/core/theme/theme.dart';
import '/src/core/widgets/common.dart';
import '/src/core/widgets/icon_of.dart';

class AuthService {
  static const _reasonLogin = 'Please authenticate to log into the app';
  static const _cancelButton = Text(
    'Cancel',
    maxLines: 1,
    softWrap: false,
    textAlign: TextAlign.center,
    overflow: TextOverflow.visible,
  );
  static const _keyPadConfig = KeyPadConfig(
    clearOnLongPressed: true,
  );
  static const _secretsConfig = SecretsConfig(
    secretConfig: SecretConfig(
      borderSize: 0,
      borderColor: Colors.transparent,
      disabledColor: Colors.white38,
      enabledColor: Colors.white,
    ),
  );

  static final _screenLockConfig = ScreenLockConfig(
    backgroundColor: clIndigo900,
    titleTextStyle: textStylePoppins620,
    textStyle: textStylePoppins616,
    buttonStyle: ButtonStyle(
      backgroundColor: const MaterialStatePropertyAll(Colors.transparent),
      foregroundColor: const MaterialStatePropertyAll(Colors.white),
      shape: const MaterialStatePropertyAll(CircleBorder()),
      textStyle: MaterialStatePropertyAll(
        textStylePoppins616.copyWith(overflow: TextOverflow.visible),
      ),
    ),
  );

  final _localAuth = LocalAuthentication();
  final _passcodeController = InputController();

  Future<bool> get hasBiometrics =>
      _localAuth.getAvailableBiometrics().then((value) => value.isNotEmpty);

  Future<void> createPassCode({
    required final BuildContext context,
    required final Function onConfirmed,
  }) {
    final diContainer = context.read<DIContainer>();
    final padding = _getPadding(context);
    return screenLockCreate(
      context: context,
      canCancel: false,
      digits: diContainer.globals.passCodeLength,
      keyPadConfig: _keyPadConfig,
      secretsConfig: _secretsConfig,
      config: _screenLockConfig,
      inputController: _passcodeController,
      title: Padding(
        padding: padding,
        child: const Text('Create your passcode'),
      ),
      confirmTitle: Padding(
        padding: padding,
        child: const Text('Enter it once more'),
      ),
      cancelButton: _cancelButton,
      customizedButtonChild: const Text(
        'Reset',
        maxLines: 1,
        softWrap: false,
        textAlign: TextAlign.center,
        overflow: TextOverflow.visible,
      ),
      customizedButtonTap: _passcodeController.unsetConfirmed,
      onConfirmed: (passCode) {
        diContainer.boxSettings.passCode = passCode;
        onConfirmed();
      },
      onError: (_) {
        ScaffoldMessenger.of(context).showSnackBar(buildSnackBar(
          text: 'Wrong passcode!',
          duration: const Duration(seconds: 2),
          isFloating: true,
          isError: true,
        ));
        _vibrate();
      },
    );
  }

  Future<void> changePassCode({
    required final BuildContext context,
    required final void Function() onExit,
  }) {
    final diContainer = context.read<DIContainer>();
    final padding = _getPadding(context);
    return screenLock(
      context: context,
      correctString: diContainer.boxSettings.passCode,
      canCancel: true,
      secretsConfig: _secretsConfig,
      keyPadConfig: _keyPadConfig,
      config: _screenLockConfig,
      title: Padding(
        padding: padding,
        child: const Text('Please enter your current passcode'),
      ),
      cancelButton: _cancelButton,
      onCancelled: onExit,
      onError: (_) {
        ScaffoldMessenger.of(context).showSnackBar(buildSnackBar(
          text: 'Wrong passcode!',
          duration: const Duration(seconds: 2),
          isFloating: true,
          isError: true,
        ));
        _vibrate();
      },
      onUnlocked: () => screenLockCreate(
        context: context,
        canCancel: true,
        digits: diContainer.globals.passCodeLength,
        keyPadConfig: _keyPadConfig,
        secretsConfig: _secretsConfig,
        config: _screenLockConfig,
        title: Padding(
          padding: padding,
          child: const Text('Please create your new passcode'),
        ),
        confirmTitle: Padding(
          padding: padding,
          child: const Text('Please repeate your new passcode'),
        ),
        onConfirmed: (value) {
          diContainer.boxSettings.passCode = value;
          showModalBottomSheet(
            context: context,
            isScrollControlled: false,
            builder: (BuildContext context) => BottomSheetWidget(
              icon: const IconOf.secrets(isBig: true, bage: BageType.ok),
              titleString: 'Passcode changed',
              textString: 'Your login passcode was changed successfully.',
              footer: PrimaryButton(text: 'Done', onPressed: onExit),
            ),
          );
        },
        cancelButton: _cancelButton,
        onCancelled: onExit,
        onError: (_) {
          ScaffoldMessenger.of(context).showSnackBar(buildSnackBar(
            text: 'Wrong passcode!',
            duration: const Duration(seconds: 2),
            isFloating: true,
            isError: true,
          ));
          _vibrate();
        },
      ),
    );
  }

  Future<void> checkPassCode({
    required final BuildContext context,
    required final void Function() onUnlock,
    required final bool canCancel,
  }) async {
    final settings = context.read<DIContainer>().boxSettings.readWhole();
    return screenLock(
      context: context,
      correctString: settings.passCode,
      canCancel: canCancel,
      cancelButton: _cancelButton,
      keyPadConfig: _keyPadConfig,
      secretsConfig: _secretsConfig,
      config: _screenLockConfig,
      title: Padding(
        padding: _getPadding(context),
        child: const Text('Please enter your current passcode'),
      ),
      customizedButtonChild: settings.isBiometricsEnabled
          ? const IconOf.biometricLogon(bgColor: Colors.transparent, size: 48)
          : null,
      customizedButtonTap: settings.isBiometricsEnabled
          ? () => _localAuthenticate(onUnlock)
          : null,
      onOpened: settings.isBiometricsEnabled
          ? () => _localAuthenticate(onUnlock)
          : null,
      onUnlocked: onUnlock,
      onError: (_) {
        ScaffoldMessenger.of(context).showSnackBar(buildSnackBar(
          text: 'Wrong passcode!',
          duration: const Duration(seconds: 2),
          isFloating: true,
          isError: true,
        ));
        _vibrate();
      },
    );
  }

  EdgeInsets _getPadding(BuildContext context) =>
      (MediaQuery.of(context).size.height > 600 ? paddingV32 : paddingV12) +
      paddingH20;

  Future<void> _localAuthenticate(final void Function() onUnlock) async {
    try {
      if (await _localAuth.authenticate(
        localizedReason: _reasonLogin,
        options: const AuthenticationOptions(biometricOnly: true),
      )) onUnlock();
    } catch (_) {}
  }

  Future<bool> _vibrate([int duration = 500]) async {
    final hasVibrator = await Vibration.hasVibrator() ?? false;
    if (hasVibrator) await Vibration.vibrate(duration: duration);
    return hasVibrator;
  }
}
