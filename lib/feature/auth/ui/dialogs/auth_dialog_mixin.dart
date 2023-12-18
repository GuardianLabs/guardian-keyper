import 'package:flutter_screen_lock/flutter_screen_lock.dart';

import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/ui/utils/screen_size.dart';

abstract class AuthDialogBase {
  static const keyPadConfig = KeyPadConfig(clearOnLongPressed: true);

  static const cancelButton = Text(
    'Cancel',
    maxLines: 1,
    softWrap: false,
    textAlign: TextAlign.center,
    overflow: TextOverflow.visible,
  );

  static const resetButton = Text(
    'Reset',
    maxLines: 1,
    softWrap: false,
    textAlign: TextAlign.center,
    overflow: TextOverflow.visible,
  );

  static const currentPassCodeTitle =
      Text('Please enter your current passcode');

  static const secretsConfig = SecretsConfig(
    secretConfig: SecretConfig(
      borderSize: 0,
      borderColor: Colors.transparent,
      disabledColor: Colors.white38,
    ),
  );

  static final wrongPassCodeSnackbar = buildSnackBar(
    text: 'Wrong passcode!',
    isFloating: true,
    isError: true,
  );

  static EdgeInsets getPadding(BuildContext context) =>
      paddingH20 +
      (ScreenSize.get(MediaQuery.of(context).size) is ScreenSmall
          ? paddingV12
          : paddingV32);

  static ScreenLockConfig getScreenLockConfig(BuildContext context) {
    final theme = Theme.of(context);
    return ScreenLockConfig(
      backgroundColor: theme.colorScheme.background,
      textStyle: theme.textTheme.titleMedium,
      titleTextStyle: theme.textTheme.titleLarge,
      buttonStyle: ButtonStyle(
        backgroundColor: MaterialStatePropertyAll(theme.colorScheme.background),
        foregroundColor:
            MaterialStatePropertyAll(theme.colorScheme.onBackground),
        side: const MaterialStatePropertyAll(BorderSide.none),
        textStyle: MaterialStatePropertyAll(
          theme.textTheme.titleMedium?.copyWith(overflow: TextOverflow.visible),
        ),
      ),
    );
  }
}
