import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'model/core_model.dart';
import 'adapter/hive_adapter.dart';
import 'service/auth_service.dart';
import 'service/analytics_service.dart';
import 'service/p2p_network_service.dart';
import 'service/platform_service.dart';
import 'utils/migrate_storage.dart';

export 'package:provider/provider.dart';
export 'package:hive_flutter/hive_flutter.dart';
export 'adapter/hive_adapter.dart';

class DIContainer with WidgetsBindingObserver {
  final Globals globals;
  final AuthService authService;
  final AnalyticsService analyticsService;
  final PlatformService platformService;
  final P2PNetworkService networkService;
  final Box<SettingsModel> boxSettings;
  final Box<MessageModel> boxMessages;
  final Box<RecoveryGroupModel> boxRecoveryGroups;

  late PeerId _myPeerId;

  DIContainer({
    required this.globals,
    required this.authService,
    required this.networkService,
    required this.platformService,
    required this.analyticsService,
    required this.boxSettings,
    required this.boxMessages,
    required this.boxRecoveryGroups,
  }) : _myPeerId = PeerId(
          token: networkService.router.selfId.value,
          name: boxSettings.deviceName,
        ) {
    WidgetsBinding.instance.addObserver(this);
    boxSettings.watch().listen(
          (event) => _myPeerId = PeerId(
            token: networkService.router.selfId.value,
            name: (event.value as SettingsModel).deviceName,
          ),
        );
  }

  PeerId get myPeerId => _myPeerId;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state != AppLifecycleState.resumed) {
      await boxSettings.flush();
      await boxRecoveryGroups.flush();
      await boxMessages.flush();
    }
  }
}

Future<DIContainer> initDIC({
  final Globals globals = const Globals(),
  final AuthService? authService,
  P2PNetworkService? networkService,
  final PlatformService platformService = const PlatformService(),
  final AnalyticsService analyticsService = const AnalyticsService(),
}) async {
  final storedKeyBunch = await platformService.readKeyBunch();
  networkService ??= P2PNetworkService(globals: globals);
  final keyBunch = await networkService.init(storedKeyBunch);
  if (keyBunch != storedKeyBunch) {
    await platformService.writeKeyBunch(keyBunch);
  }

  final cipher = HiveAesCipher(keyBunch.encryptionAesKey);
  await Hive.initFlutter(globals.storageName);
  Hive
    ..registerAdapter<MessageModel>(MessageModelAdapter())
    ..registerAdapter<SettingsModel>(SettingsModelAdapter())
    ..registerAdapter<SecretShardModel>(SecretShardModelAdapter())
    ..registerAdapter<RecoveryGroupModel>(RecoveryGroupModelAdapter());

  final boxMessages = await Hive.openBox<MessageModel>(
    MessageModel.boxName,
    encryptionCipher: cipher,
  );
  final boxSettings = await Hive.openBox<SettingsModel>(
    SettingsModel.boxName,
    encryptionCipher: cipher,
  );
  final boxSecretShards = await Hive.openBox<SecretShardModel>(
    SecretShardModel.boxName,
    encryptionCipher: cipher,
  );
  final boxRecoveryGroups = await Hive.openBox<RecoveryGroupModel>(
    RecoveryGroupModel.boxName,
    encryptionCipher: cipher,
  );
  if (boxSettings.deviceName.isEmpty) {
    boxSettings.deviceName =
        await platformService.getDeviceName(keyBunch.encryptionPublicKey);
  }
  await migrateStorage(
    myPeerId: PeerId(
      token: networkService.router.selfId.value,
      name: boxSettings.deviceName,
    ),
    boxMessages: boxMessages,
    boxSecretShards: boxSecretShards,
    boxRecoveryGroups: boxRecoveryGroups,
  );
  if (boxSettings.isProxyEnabled) {
    networkService.addBootstrapServer(
      peerId: globals.bsPeerId,
      ipV4: globals.bsAddressV4,
      ipV6: globals.bsAddressV6,
      port: globals.bsPort,
    );
  }
  return DIContainer(
    globals: globals,
    authService: authService ?? AuthService(),
    boxSettings: boxSettings,
    boxMessages: boxMessages,
    boxRecoveryGroups: boxRecoveryGroups,
    platformService: platformService,
    networkService: networkService,
    analyticsService: analyticsService,
  );
}
