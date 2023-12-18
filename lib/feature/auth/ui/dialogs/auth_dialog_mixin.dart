import 'package:flutter_screen_lock/flutter_screen_lock.dart';

import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/ui/utils/screen_size.dart';

mixin class AuthDialogMixin {
  static const cancelButton = Icon(Icons.cancel);

  static const resetButton = Icon(Icons.cancel);

  static const currentPassCodeTitle =
      Text('Please enter your current passcode');

  static const keyPadConfig = KeyPadConfig(clearOnLongPressed: true);

  static EdgeInsets getPadding(BuildContext context) =>
      paddingH20 +
      (ScreenSize.get(MediaQuery.of(context).size) is ScreenSmall
          ? const EdgeInsets.symmetric(vertical: 12)
          : const EdgeInsets.symmetric(vertical: 32));

  static ScreenLockConfig getScreenLockConfig(BuildContext context) {
    final theme = Theme.of(context);
    return ScreenLockConfig(
      themeData: theme,
      backgroundColor: theme.colorScheme.surface.withOpacity(0.5),
      textStyle: theme.textTheme.titleMedium,
      titleTextStyle: theme.textTheme.titleLarge,
      buttonStyle: ButtonStyle(
        foregroundColor: MaterialStatePropertyAll(theme.colorScheme.onSurface),
        side: const MaterialStatePropertyAll(BorderSide.none),
      ),
    );
  }
}
