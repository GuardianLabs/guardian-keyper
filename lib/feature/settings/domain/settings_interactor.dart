import 'package:get_it/get_it.dart';

import 'package:guardian_keyper/data/network_manager.dart';
import 'package:guardian_keyper/data/platform_service.dart';
import 'package:guardian_keyper/domain/entity/peer_id.dart';

import '../data/settings_manager.dart';

class SettingsInteractor {
  late final vibrate = _platformManager.vibrate;
  late final setPassCode = _settingsManager.setPassCode;
  late final setDeviceName = _settingsManager.setDeviceName;
  late final setIsBiometricsEnabled = _settingsManager.setIsBiometricsEnabled;

  PeerId get selfId => _settingsManager.selfId;
  String get passCode => _settingsManager.passCode;
  String get deviceName => _settingsManager.deviceName;
  bool get hasBiometrics => _settingsManager.hasBiometrics;
  bool get useBiometrics => hasBiometrics && isBiometricsEnabled;
  bool get isBootstrapEnabled => _settingsManager.isBootstrapEnabled;
  bool get isBiometricsEnabled => _settingsManager.isBiometricsEnabled;
  Stream<SettingsEvent> get watch => _settingsManager.changes;

  Future<void> setIsBootstrapEnabled(final bool isEnabled) async {
    _networkManager.toggleBootstrap(isEnabled);
    await _settingsManager.setIsBootstrapEnabled(isEnabled);
  }

  final _networkManager = GetIt.I<NetworkManager>();
  final _settingsManager = GetIt.I<SettingsManager>();
  final _platformManager = GetIt.I<PlatformService>();
}
