import 'package:get_it/get_it.dart';

import 'package:guardian_keyper/data/repositories/settings_repository.dart';

class SettingsThemeCase {
  late final _settingsRepository = GetIt.I<SettingsRepository>();

  Stream<bool?> get events => _settingsRepository
      .watch<bool>(SettingsRepositoryKeys.keyIsDarkModeOn)
      .map<bool?>((e) => e.value);

  bool? get isDarkMode =>
      _settingsRepository.get<bool>(SettingsRepositoryKeys.keyIsDarkModeOn);

  Future<void> setIsDarkMode(bool? isDarkModeOn) =>
      _settingsRepository.putNullable<bool>(
        SettingsRepositoryKeys.keyIsDarkModeOn,
        isDarkModeOn,
      );
}
