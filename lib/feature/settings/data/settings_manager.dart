import 'dart:async';
import 'package:get_it/get_it.dart';

import 'package:guardian_keyper/domain/entity/peer_id.dart';
import 'package:guardian_keyper/data/network_manager.dart';
import 'package:guardian_keyper/data/services/platform_service.dart';
import 'package:guardian_keyper/data/services/preferences_service.dart';

typedef SettingsEvent = ({String key, Object value});

class SettingsManager {
  PeerId get selfId => _selfId;
  String get passCode => _passCode;
  String get deviceName => _deviceName;
  bool get hasBiometrics => _hasBiometrics;
  bool get isBootstrapEnabled => _isBootstrapEnabled;
  bool get isBiometricsEnabled => _isBiometricsEnabled;
  Stream<SettingsEvent> get changes => _updatesStreamController.stream;

  final _platformService = GetIt.I<PlatformService>();
  final _preferencesService = GetIt.I<PreferencesService>();
  final _updatesStreamController = StreamController<SettingsEvent>.broadcast();

  late PeerId _selfId;
  late String _passCode, _deviceName;
  late bool _isBiometricsEnabled, _isBootstrapEnabled, _hasBiometrics;

  Future<SettingsManager> init() async {
    _passCode = await _preferencesService.get<String>(keyPassCode) ?? '';
    _isBootstrapEnabled =
        await _preferencesService.get<bool>(keyIsBootstrapEnabled) ?? true;
    _isBiometricsEnabled =
        await _preferencesService.get<bool>(keyIsBiometricsEnabled) ?? true;
    _deviceName = await _preferencesService.get<String>(keyDeviceName) ??
        await _platformService.getDeviceName();
    _selfId = PeerId(
      token: GetIt.I<NetworkManager>().selfId,
      name: _deviceName,
    );

    await getHasBiometrics();
    return this;
  }

  Future<bool> getHasBiometrics() => _platformService
      .getAvailableBiometrics()
      .then((value) => _hasBiometrics = value.isNotEmpty);

  Future<void> setDeviceName(final String value) async {
    _deviceName = value;
    _selfId = _selfId.copyWith(name: value);
    await _preferencesService.set<String>(keyDeviceName, value);
    _updatesStreamController.add((key: keyDeviceName, value: value));
  }

  Future<void> setPassCode(final String value) async {
    _passCode = value;
    await _preferencesService.set<String>(keyPassCode, value);
    _updatesStreamController.add((key: keyPassCode, value: value));
  }

  Future<void> setIsBootstrapEnabled(final bool value) async {
    _isBootstrapEnabled = value;
    await _preferencesService.set<bool>(keyIsBootstrapEnabled, value);
    _updatesStreamController.add((key: keyIsBootstrapEnabled, value: value));
  }

  Future<void> setIsBiometricsEnabled(final bool value) async {
    _isBiometricsEnabled = value;
    await _preferencesService.set<bool>(keyIsBiometricsEnabled, value);
    _updatesStreamController.add((key: keyIsBiometricsEnabled, value: value));
  }
}
