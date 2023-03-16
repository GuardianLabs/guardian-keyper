import '/src/core/consts.dart';
import '/src/core/service/service.dart';
import '/src/core/repository/repository.dart';

import '/src/guardian/guardian_controller.dart';
import '/src/auth/auth_case.dart';

Future<void> init() async {
  registerServices();
  registerRepositories();

  final networkService = GetIt.I<NetworkService>();
  final settingsRepository = GetIt.I<SettingsRepository>();

  await settingsRepository.init();
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

  final cipher = HiveAesCipher(seed);
  GetIt.I.registerSingleton<Box<MessageModel>>(
    await Hive.openBox<MessageModel>(
      MessageModel.boxName,
      encryptionCipher: cipher,
    ),
  );
  GetIt.I.registerSingleton<Box<RecoveryGroupModel>>(
    await Hive.openBox<RecoveryGroupModel>(
      RecoveryGroupModel.boxName,
      encryptionCipher: cipher,
    ),
  );

  GetIt.I.registerSingleton<AuthCase>(AuthCase());

  final guardianController = GuardianController();
  await guardianController.pruneMessages();
  GetIt.I.registerSingleton<GuardianController>(guardianController);
}
