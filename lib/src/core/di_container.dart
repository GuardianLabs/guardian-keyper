import 'package:hive_flutter/hive_flutter.dart';

export 'package:provider/provider.dart';
export 'package:hive_flutter/hive_flutter.dart';

import 'model/core_model.dart';
import 'service/analytics_service.dart';
import 'service/network_service.dart';
import 'service/platform_service.dart';

class DIContainer {
  final Globals globals;
  final AnalyticsService analyticsService;
  final PlatformService platformService;
  final NetworkService networkService;
  final Box<SettingsModel> boxSettings;
  final Box<MessageModel> boxMessages;
  final Box<RecoveryGroupModel> boxRecoveryGroups;

  late PeerId _myPeerId;

  PeerId get myPeerId => _myPeerId;

  DIContainer({
    required this.globals,
    required this.platformService,
    required this.analyticsService,
    required this.networkService,
    required this.boxSettings,
    required this.boxMessages,
    required this.boxRecoveryGroups,
  }) : _myPeerId = PeerId(
          token: networkService.router.selfId.value,
          name: boxSettings.deviceName,
        ) {
    boxSettings.watch().listen(
          (event) => _myPeerId = PeerId(
            token: networkService.router.selfId.value,
            name: (event.value as SettingsModel).deviceName,
          ),
        );
  }
}

extension SettingsModelExt on Box<SettingsModel> {
  SettingsModel readWhole() => get(0) ?? const SettingsModel();
  Future<void> writeWhole(SettingsModel settings) => put(0, settings);

  String get passCode => readWhole().passCode;
  String get deviceName => readWhole().deviceName;
  bool get isBiometricsEnabled => readWhole().isBiometricsEnabled;
  bool get isProxyEnabled => readWhole().isProxyEnabled;

  set passCode(String value) =>
      writeWhole(readWhole().copyWith(passCode: value));
  set deviceName(String value) =>
      writeWhole(readWhole().copyWith(deviceName: value));
  set isBiometricsEnabled(bool value) =>
      writeWhole(readWhole().copyWith(isBiometricsEnabled: value));
  set isProxyEnabled(bool value) =>
      writeWhole(readWhole().copyWith(isProxyEnabled: value));
}
