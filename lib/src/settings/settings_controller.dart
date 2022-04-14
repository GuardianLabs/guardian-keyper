import 'package:flutter/material.dart';

import '../core/service/event_bus.dart';
import 'settings_model.dart';
import 'settings_service.dart';

class SettingsController with ChangeNotifier {
  SettingsController({
    required SettingsService settingsService,
    required EventBus eventBus,
    required this.keyPair,
  })  : _settingsService = settingsService,
        _eventBus = eventBus;

  final SettingsService _settingsService;
  final EventBus _eventBus;
  final KeyPairModel keyPair;

  ThemeMode _themeMode = ThemeMode.system;

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

  void clearRecoveryGroups() => _eventBus.fire(RecoveryGroupClearCommand());

  void clearGuardianShards() => _eventBus.fire(GuardianShardsClearCommand());

  void clearGuardianPeers() => _eventBus.fire(GuardianPeersClearCommand());
}
