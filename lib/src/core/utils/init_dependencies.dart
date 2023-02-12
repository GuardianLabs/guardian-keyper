import '../di_container.dart';
import '../model/core_model.dart';
import '../service/analytics_service.dart';
import '../service/p2p_network_service.dart';
import '../service/platform_service.dart';

import 'migrate_storage.dart';

Future<DIContainer> initDependencies({
  required final Globals globals,
  required final P2PNetworkService networkService,
  required final PlatformService platformService,
  required final AnalyticsService analyticsService,
}) async {
  final storedKeyBunch = await platformService.readKeyBunch();
  final keyBunch = await networkService.init(storedKeyBunch);
  if (keyBunch != storedKeyBunch) await platformService.writeKeyBunch(keyBunch);

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
    networkService.setBootstrapServer(
      peerId: globals.bsPeerId,
      ipV4: globals.bsAddressV4,
      ipV6: globals.bsAddressV6,
      port: globals.bsPort,
    );
  }
  return DIContainer(
    globals: globals,
    boxSettings: boxSettings,
    boxMessages: boxMessages,
    boxRecoveryGroups: boxRecoveryGroups,
    platformService: platformService,
    networkService: networkService,
    analyticsService: analyticsService,
  );
}
