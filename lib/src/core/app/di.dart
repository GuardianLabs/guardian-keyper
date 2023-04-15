import 'package:get_it/get_it.dart';

import 'consts.dart';
import '../data/network_manager.dart';
import '../data/platform_gateway.dart';
import '../data/analytics_gateway.dart';

import '/src/message/data/message_repository.dart';
import '/src/settings/data/settings_manager.dart';
import '/src/vaults/data/vault_repository.dart';

abstract class DI {
  static bool _isInited = false;

  static Future<bool> init() async {
    if (_isInited) return true;

    GetIt.I.registerSingleton<AnalyticsGateway>(
        await AnalyticsGateway.init(Envs.amplitudeKey));

    GetIt.I.registerSingleton<PlatformGateway>(const PlatformGateway());

    final settingsManager = SettingsManager();
    await settingsManager.init();
    GetIt.I.registerSingleton<SettingsManager>(settingsManager);

    final networkManager = NetworkManager();
    final aesKey = await networkManager.init();
    GetIt.I.registerSingleton<NetworkManager>(networkManager);

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
