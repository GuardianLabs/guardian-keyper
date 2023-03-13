import '/src/core/consts.dart';
import '/src/core/model/core_model.dart';
import '/src/core/adapter/hive_adapter.dart';
import '/src/core/service/platform_service.dart';
import '/src/core/service/analytics_service.dart';
import '/src/core/service/p2p_network_service.dart';

import '/src/auth/auth_controller.dart';
import '/src/settings/settings_controller.dart';
import '/src/settings/settings_repository.dart';
import '/src/guardian/guardian_controller.dart';

Future<void> init() async {
  final networkService = P2PNetworkService();
  GetIt.I.registerSingleton<P2PNetworkService>(networkService);

  final settingsRepository = SettingsRepository();

  final seedSaved = await settingsRepository.getSeedKey();
  final seedInited = await networkService.init(seedSaved);
  if (seedSaved.isEmpty) await settingsRepository.setSeedKey(seedInited);

  await Hive.initFlutter('data_v1');
  Hive
    ..registerAdapter<MessageModel>(MessageModelAdapter())
    ..registerAdapter<RecoveryGroupModel>(RecoveryGroupModelAdapter());

  final cipher = HiveAesCipher(seedInited);

  GetIt.I.registerSingleton<Box<MessageModel>>(await Hive.openBox<MessageModel>(
    MessageModel.boxName,
    encryptionCipher: cipher,
  ));
  GetIt.I.registerSingleton<Box<RecoveryGroupModel>>(
      await Hive.openBox<RecoveryGroupModel>(
    RecoveryGroupModel.boxName,
    encryptionCipher: cipher,
  ));

  GetIt.I.registerSingleton<PlatformService>(const PlatformService());
  GetIt.I.registerSingleton<AnalyticsService>(
    await AnalyticsService.init(Envs.amplitudeKey),
  );

  // register controllers
  final settingsController =
      SettingsController(settingsRepository: settingsRepository);
  await settingsController.init();
  GetIt.I.registerSingleton<SettingsController>(settingsController);

  GetIt.I.registerSingleton<AuthController>(const AuthController());
  GetIt.I.registerSingleton<GuardianController>(GuardianController());

  await GetIt.I<GuardianController>().pruneMessages();
  await networkService.start();

  if (settingsController.state.isBootstrapEnabled) {
    networkService.addBootstrapServer(
      peerId: Envs.bsPeerId,
      ipV4: Envs.bsAddressV4,
      ipV6: Envs.bsAddressV6,
      port: Envs.bsPort,
    );
  }
}
