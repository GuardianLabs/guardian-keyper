import '../di_container.dart';
import '../model/core_model.dart';
import '../adapter/hive_adapter.dart';
import '../service/analytics_service.dart';
import '../service/network_service.dart';
import '../service/platform_service.dart';

import 'migrate_storage.dart';

Future<DIContainer> initDependencies({
  Globals globals = const Globals(),
  PlatformService platformService = const PlatformService(),
  AnalyticsService analyticsService = const AnalyticsService(),
}) async {
  await initCrypto();
  final keyBunch = await platformService.getKeyBunch(generateKeyBunch);
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
  final networkService = NetworkService.udp(
    keyBunch: keyBunch,
    bsAddressV4: boxSettings.isProxyEnabled ? globals.bsAddressV4 : '',
    bsAddressV6: boxSettings.isProxyEnabled ? globals.bsAddressV6 : '',
  );
  final myPeerId = PeerId(
    token: networkService.router.pubKey.data,
    name: boxSettings.deviceName,
  );
  await migrateStorage(
    myPeerId: myPeerId,
    boxMessages: boxMessages,
    boxSecretShards: boxSecretShards,
    boxRecoveryGroups: boxRecoveryGroups,
  );
  return DIContainer(
    myPeerId: myPeerId,
    globals: globals,
    boxSettings: boxSettings,
    boxMessages: boxMessages,
    boxRecoveryGroups: boxRecoveryGroups,
    platformService: platformService,
    networkService: networkService,
    analyticsService: analyticsService,
  );
}
