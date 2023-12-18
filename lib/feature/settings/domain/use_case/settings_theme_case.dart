import 'package:get_it/get_it.dart';

import 'package:guardian_keyper/data/repositories/settings_repository.dart';

class SettingsThemeCase {
  late final _settingsRepository = GetIt.I<SettingsRepository>();

  Stream<bool?> get events => _settingsRepository
      .watch(SettingsRepositoryKeys.keyIsDarkModeOn)
      .map<bool?>((e) => bool.tryParse((e.value as String?) ?? ''));

  bool? get isDarkMode => bool.tryParse(
      _settingsRepository.get(SettingsRepositoryKeys.keyIsDarkModeOn) ?? '');

  Future<void> setIsDarkMode(bool? isDarkModeOn) {
    return isDarkModeOn == null
        ? _settingsRepository.delete(SettingsRepositoryKeys.keyIsDarkModeOn)
        : _settingsRepository.put(
            SettingsRepositoryKeys.keyIsDarkModeOn,
            isDarkModeOn.toString(),
          );
  }
}
