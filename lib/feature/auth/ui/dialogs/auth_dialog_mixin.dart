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
      paddingHDefault +
      (ScreenSize(context) is ScreenSmall
          ? const EdgeInsets.symmetric(vertical: 12)
          : const EdgeInsets.symmetric(vertical: 32));

  static ScreenLockConfig getScreenLockConfig(BuildContext context) {
    final theme = Theme.of(context);
    return ScreenLockConfig(
      themeData: theme,
      backgroundColor: theme.colorScheme.surfaceTint.withOpacity(0.8),
      textStyle: theme.textTheme.titleMedium,
      titleTextStyle: theme.textTheme.titleLarge,
      buttonStyle: ButtonStyle(
        foregroundColor: WidgetStatePropertyAll(theme.colorScheme.onSurface),
        side: const WidgetStatePropertyAll(BorderSide.none),
        shape: const WidgetStatePropertyAll(CircleBorder(
          side: BorderSide.none,
        )),
      ),
    );
  }
}
