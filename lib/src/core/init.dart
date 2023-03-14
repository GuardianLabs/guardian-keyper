import '/src/core/consts.dart';
import '/src/core/adapter/hive_adapter.dart';
import '/src/core/service/platform_service.dart';
import '/src/core/service/analytics_service.dart';
import '/src/core/service/p2p_network_service.dart';

import '/src/settings/settings_repository.dart';
import '/src/guardian/guardian_controller.dart';
import '/src/auth/auth_controller.dart';

Future<void> init() async {
  GetIt.I.registerSingleton<PlatformService>(const PlatformService());

  GetIt.I.registerSingleton<AnalyticsService>(
    await AnalyticsService.init(Envs.amplitudeKey),
  );

  final settingsRepository = SettingsRepository();
  await settingsRepository.init();
  GetIt.I.registerSingleton<SettingsRepository>(settingsRepository);

  final networkService = P2PNetworkService();
  final seed = await networkService.init(settingsRepository.seed);
  await settingsRepository.setSeedKey(seed);
  if (settingsRepository.state.isBootstrapEnabled) {
    networkService.addBootstrapServer(
      peerId: Envs.bsPeerId,
      ipV4: Envs.bsAddressV4,
      ipV6: Envs.bsAddressV6,
      port: Envs.bsPort,
    );
  }
  GetIt.I.registerSingleton<P2PNetworkService>(networkService);

  await Hive.initFlutter('data_v1');
  Hive
    ..registerAdapter<MessageModel>(MessageModelAdapter())
    ..registerAdapter<RecoveryGroupModel>(RecoveryGroupModelAdapter());
  final cipher = HiveAesCipher(seed);
  GetIt.I.registerSingleton<Box<MessageModel>>(await Hive.openBox<MessageModel>(
    MessageModel.boxName,
    encryptionCipher: cipher,
  ));
  GetIt.I.registerSingleton<Box<RecoveryGroupModel>>(
      await Hive.openBox<RecoveryGroupModel>(
    RecoveryGroupModel.boxName,
    encryptionCipher: cipher,
  ));

  GetIt.I.registerSingleton<AuthController>(const AuthController());

  final guardianController = GuardianController();
  await guardianController.pruneMessages();
  GetIt.I.registerSingleton<GuardianController>(guardianController);
}
