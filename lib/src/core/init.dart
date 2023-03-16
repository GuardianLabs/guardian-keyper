import '/src/core/consts.dart';
import '/src/core/service/service_root.dart';
import '/src/core/repository/repository_root.dart';

import '/src/guardian/guardian_controller.dart';
import '/src/auth/auth_case.dart';

Future<void> init() async {
  final serviceRoot = await ServiceRoot.init();
  final rootRepository = await RepositoryRoot.init();

  await rootRepository.settingsRepository.setSeed(
    await serviceRoot.networkService.init(
      await rootRepository.settingsRepository.getSeed(),
    ),
  );

  if (rootRepository.settingsRepository.state.isBootstrapEnabled) {
    serviceRoot.networkService.addBootstrapServer(
      peerId: Envs.bsPeerId,
      ipV4: Envs.bsAddressV4,
      ipV6: Envs.bsAddressV6,
      port: Envs.bsPort,
    );
  }

  GetIt.I.registerSingleton<AuthCase>(AuthCase());

  final guardianController = GuardianController();
  await guardianController.pruneMessages();
  GetIt.I.registerSingleton<GuardianController>(guardianController);
}
