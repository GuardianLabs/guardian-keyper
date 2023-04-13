import 'package:get_it/get_it.dart';

import '/src/core/consts.dart';
import '/src/core/data/platform_manager.dart';
import '/src/core/service/network/network_service.dart';
import '/src/core/infrastructure/analytics_service.dart';
import '/src/settings/data/settings_repository.dart';
import '/src/message/data/message_repository.dart';
import '/src/vaults/data/vault_repository.dart';

abstract class DI {
  static const _initLimit = Duration(seconds: 5);
  static bool _isInited = false;

  static Future<bool> init() async {
    if (_isInited) return true;

    GetIt.I.registerSingleton<AnalyticsService>(
      await AnalyticsService.init(Envs.amplitudeKey),
    );

    final platformManager = await PlatformManager.init();
    GetIt.I.registerSingleton<PlatformManager>(platformManager);

    final settingsRepository = SettingsRepository(
      defaultName: await platformManager.getDeviceName(),
    );
    await settingsRepository.load();
    GetIt.I.registerSingleton<SettingsRepository>(settingsRepository);

    // Init network service with given seed (generates if empty)
    // Returns given or generated seed
    final networkService = NetworkService(
      useBootstrapFromEnvs: settingsRepository.settings.isBootstrapEnabled,
    );
    final aesKey = await networkService
        .init(settingsRepository.settings.seed)
        .timeout(_initLimit);
    // save seed (saves only if it was empty)
    await settingsRepository.setSeed(aesKey);
    GetIt.I.registerSingleton<NetworkService>(networkService);

    // Register Hive Boxes
    await Hive.initFlutter('data_v1');
    final cipher = HiveAesCipher(aesKey);
    GetIt.I.registerSingleton<MessageRepository>(
      await getMessageRepository(cipher: cipher),
    );
    GetIt.I.registerSingleton<VaultRepository>(
      await getVaultRepository(cipher: cipher),
    );

    return _isInited = true;
  }
}
