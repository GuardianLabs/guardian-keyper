import 'package:flutter/material.dart';

import '/src/core/service/event_bus.dart';

import 'settings_model.dart';
import 'settings_service.dart';

class SettingsController with ChangeNotifier {
  final SettingsService _settingsService;
  final EventBus _eventBus;
  final themeMode = ThemeMode.dark;
  final KeyPairModel keyPair;

  String _deviceName = '';
  String _pinCode = '';

  SettingsController({
    required SettingsService settingsService,
    required EventBus eventBus,
    required this.keyPair,
  })  : _settingsService = settingsService,
        _eventBus = eventBus;

  String get deviceName => _deviceName;
  String get pinCode => _pinCode;

  Future<void> setDeviceName(String deviceName) async {
    _deviceName = deviceName;
    _eventBus.fire(SettingsChangedEvent(deviceName: deviceName));
    await _save();
  }

  Future<void> setPinCode(String pinCode) async {
    _pinCode = pinCode;
    await _save();
  }

  void clearRecoveryGroups() => _eventBus.fire(RecoveryGroupClearCommand());

  void clearGuardianShards() => _eventBus.fire(GuardianShardsClearCommand());

  void clearGuardianPeers() => _eventBus.fire(GuardianPeersClearCommand());

  Future<void> load() async {
    final settings = await _settingsService.load();
    _deviceName = settings.deviceName;
    _pinCode = settings.pinCode;
    notifyListeners();
  }

  Future<void> _save() async {
    await _settingsService.save(SettingsModel(
      deviceName: _deviceName,
      pinCode: _pinCode,
    ));
    notifyListeners();
  }
}
