import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';

import 'package:guardian_keyper/data/services/preferences_service.dart';

export 'package:provider/provider.dart';

class ThemePresenter extends ChangeNotifier {
  ThemePresenter({bool? isDarkModeOn})
      : _themeMode = switch (isDarkModeOn) {
          true => ThemeMode.dark,
          false => ThemeMode.light,
          null => ThemeMode.system,
        };
  final _preferencesService = GetIt.I<PreferencesService>();

  ThemeMode _themeMode;

  ThemeMode get themeMode => _themeMode;

  Future<void> setThemeMode(ThemeMode themeMode) async {
    switch (themeMode) {
      case ThemeMode.dark:
        await _preferencesService.set(PreferencesKeys.keyIsDarkModeOn, true);
      case ThemeMode.light:
        await _preferencesService.set(PreferencesKeys.keyIsDarkModeOn, false);
      case ThemeMode.system:
        await _preferencesService.delete(PreferencesKeys.keyIsDarkModeOn);
    }
    _themeMode = themeMode;
    notifyListeners();
  }
}
