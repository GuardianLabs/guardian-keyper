import 'dart:async';
import 'package:get_it/get_it.dart';

import 'package:guardian_keyper/data/services/preferences_service.dart';
import 'package:guardian_keyper/feature/settings/domain/settings_repository_event.dart';

class SettingsRepository {
  final _preferencesService = GetIt.I<PreferencesService>();

  final _eventsStreamController =
      StreamController<SettingsRepositoryEvent>.broadcast();

  bool? _isDarkMode;

  Stream<SettingsRepositoryEvent> get events => _eventsStreamController.stream;

  bool? get isDarkMode => _isDarkMode;

  Future<SettingsRepository> init() async {
    _isDarkMode =
        await _preferencesService.get<bool>(PreferencesKeys.keyIsDarkThemeMode);

    return this;
  }

  Future<void> setIsDarkMode(bool? isDarkMode) {
    _isDarkMode = isDarkMode;
    _eventsStreamController.add(SettingsRepositoryEventThemeMode(
      isDarkModeOn: isDarkMode,
    ));
    return isDarkMode == null
        ? _preferencesService.delete(PreferencesKeys.keyIsDarkThemeMode)
        : _preferencesService.set<bool>(
            PreferencesKeys.keyIsDarkThemeMode,
            isDarkMode,
          );
  }
}
