import 'package:flutter/material.dart';

mixin class ThemeModeMapper {
  ThemeMode mapBoolToThemeMode(bool? isDarkModeOn) => switch (isDarkModeOn) {
        true => ThemeMode.dark,
        false => ThemeMode.light,
        null => ThemeMode.system,
      };

  bool? mapThemeModeToBool(ThemeMode themeMode) => switch (themeMode) {
        ThemeMode.dark => true,
        ThemeMode.light => false,
        ThemeMode.system => null,
      };
}
