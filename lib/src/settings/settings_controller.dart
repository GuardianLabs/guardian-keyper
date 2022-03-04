import 'package:flutter/material.dart';

import '../core/service/event_bus.dart';
import 'settings_model.dart';
import 'settings_service.dart';

class SettingsController with ChangeNotifier {
  SettingsController({
    required SettingsService settingsService,
    required EventBus eventBus,
  })  : _settingsService = settingsService,
        _eventBus = eventBus;

  final SettingsService _settingsService;
  final EventBus _eventBus;
  late KeyPairModel _keyPair;

  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;
  KeyPairModel get keyPair => _keyPair;

  Future<void> load() async {
    _themeMode = await _settingsService.themeMode();
    _keyPair = await _settingsService.getKeyPair();
    notifyListeners();
  }

  Future<void> updateThemeMode(ThemeMode? newThemeMode) async {
    if (newThemeMode == null) return;
    if (newThemeMode == _themeMode) return;
    _themeMode = newThemeMode;
    notifyListeners();
    await _settingsService.updateThemeMode(newThemeMode);
  }

  void clearRecoveryGroups() => _eventBus.fire(RecoveryGroupClearCommand());
}
