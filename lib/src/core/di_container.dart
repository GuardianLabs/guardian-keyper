import 'package:hive_flutter/hive_flutter.dart';

import 'model/core_model.dart';
import 'adapter/hive_adapter.dart';
import 'service/analytics_service.dart';
import 'service/p2p_network_service.dart';
import 'service/platform_service.dart';

export 'package:provider/provider.dart';
export 'package:hive_flutter/hive_flutter.dart';
export 'adapter/hive_adapter.dart';

class DIContainer {
  final Globals globals;
  final AnalyticsService analyticsService;
  final PlatformService platformService;
  final P2PNetworkService networkService;
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
