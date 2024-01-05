import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:guardian_keyper/data/services/preferences_service.dart';

export 'package:get_it/get_it.dart';
export 'package:flutter_bloc/flutter_bloc.dart';

class ThemeModeCubit extends Cubit<ThemeMode> {
  ThemeModeCubit(bool? isDarkModeOn)
      : super(switch (isDarkModeOn) {
          true => ThemeMode.dark,
          false => ThemeMode.light,
          null => ThemeMode.system,
        });

  final _preferencesService = GetIt.I<PreferencesService>();

  Future<void> setThemeMode(ThemeMode themeMode) async {
    switch (themeMode) {
      case ThemeMode.dark:
        await _preferencesService.set(PreferencesKeys.keyIsDarkModeOn, true);
      case ThemeMode.light:
        await _preferencesService.set(PreferencesKeys.keyIsDarkModeOn, false);
      case ThemeMode.system:
        await _preferencesService.delete(PreferencesKeys.keyIsDarkModeOn);
    }
    emit(themeMode);
  }
}
