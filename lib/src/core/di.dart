import 'package:flutter/foundation.dart';

import '/src/core/consts.dart';
import '/src/core/service/service_root.dart';
import '/src/core/repository/repository_root.dart';
import '/src/core/storage/flutter_secure_storage.dart';

import '/src/message/messages_controller.dart';

abstract class DI {
  static bool _isInited = false;

  static Future<bool> init() async {
    if (_isInited) return true;
    final serviceRoot = await ServiceRoot.bootstrap();
    GetIt.I.registerSingleton<ServiceRoot>(serviceRoot);

    // Init network service and save seed
    final settingsStorage = FlutterSecureStorage(storage: Storages.settings);
    // Ugly hack to fix first read returns null
    await settingsStorage.get<Uint8List>(SettingsRepositoryKeys.seed);

    // Get seed from storage
    final seed =
        await settingsStorage.get<Uint8List>(SettingsRepositoryKeys.seed);

    // Init network service
    final aesKey = await serviceRoot.networkService.init(seed);

    // Saving the seed if just generated
    if (seed == null) {
      await settingsStorage.set<Uint8List>(SettingsRepositoryKeys.seed, aesKey);
    }

    final repositoryRoot = await RepositoryRoot.bootstrap(aesKey: aesKey);
    GetIt.I.registerSingleton<RepositoryRoot>(repositoryRoot);

    if (repositoryRoot.settingsRepository.isBootstrapEnabled) {
      serviceRoot.networkService.addBootstrapServer(
        peerId: Envs.bsPeerId,
        ipV4: Envs.bsAddressV4,
        ipV6: Envs.bsAddressV6,
        port: Envs.bsPort,
      );
    }

    GetIt.I.registerSingleton<MessagesController>(MessagesController());
    return _isInited = true;
  }
}
