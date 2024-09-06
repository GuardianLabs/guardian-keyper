import 'package:flutter/material.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';

export 'package:flutter_screen_lock/flutter_screen_lock.dart';

const keyPadConfig = KeyPadConfig(clearOnLongPressed: true);

ScreenLockConfig getScreenLockConfig(BuildContext context) {
  final theme = Theme.of(context);
  return ScreenLockConfig(
    backgroundColor: Colors.transparent,
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
