import 'package:flutter/material.dart';

import '../core/service/event_bus.dart';
import 'settings_service.dart';

class SettingsController with ChangeNotifier {
  SettingsController(this._settingsService, this.eventBus);

  final SettingsService _settingsService;
  final EventBus eventBus;
  late ThemeMode _themeMode;

  ThemeMode get themeMode => _themeMode;

  Future<void> load() async {
    _themeMode = await _settingsService.themeMode();
    notifyListeners();
  }

  Future<void> updateThemeMode(ThemeMode? newThemeMode) async {
    if (newThemeMode == null) return;
    if (newThemeMode == _themeMode) return;
    _themeMode = newThemeMode;
    notifyListeners();
    await _settingsService.updateThemeMode(newThemeMode);
  }

  void clearRecoveryGroups() => eventBus.fire(RecoveryGroupClearEvent());
}
