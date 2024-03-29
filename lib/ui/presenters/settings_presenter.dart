import 'package:flutter/foundation.dart';

import 'package:guardian_keyper/data/repositories/settings_repository.dart';

export 'package:provider/provider.dart';

class SettingsPresenter extends ChangeNotifier {
  SettingsPresenter() {
    _themeChanges.resume();
  }

  final _settingsRepository = GetIt.I<SettingsRepository>();

  late final _themeChanges = _settingsRepository
      .watch<bool>(PreferencesKeys.keyIsDarkModeOn)
      .listen((_) => notifyListeners());

  bool? get isDarkModeOn => _settingsRepository.get<bool>(
        PreferencesKeys.keyIsDarkModeOn,
        // TBD: light color scheme
        true,
      );

  @override
  void dispose() {
    _themeChanges.cancel();
    super.dispose();
  }
}
