import 'package:hive_flutter/hive_flutter.dart';

import 'model/core_model.dart';
import 'adapter/hive_adapter.dart';
import 'service/p2p_network_service.dart';

import '/src/settings/settings_repository.dart';

export 'package:hive_flutter/hive_flutter.dart';
export 'package:provider/provider.dart';
export 'package:get_it/get_it.dart';

class DIContainer {
  late final Box<MessageModel> boxMessages;
  late final Box<RecoveryGroupModel> boxRecoveryGroups;
  late final networkService = P2PNetworkService();

  Future<DIContainer> init() async {
    final settingsRepository = GetIt.I<SettingsRepository>();
    final seedSaved = await settingsRepository.getSeedKey();
    final seedInited = await networkService.init(seedSaved);
    if (seedSaved.isEmpty) await settingsRepository.setSeedKey(seedInited);

    await Hive.initFlutter('data_v1');
    Hive
      ..registerAdapter<MessageModel>(MessageModelAdapter())
      ..registerAdapter<RecoveryGroupModel>(RecoveryGroupModelAdapter());

    final cipher = HiveAesCipher(seedInited);
    boxMessages = await Hive.openBox<MessageModel>(
      MessageModel.boxName,
      encryptionCipher: cipher,
    );
    boxRecoveryGroups = await Hive.openBox<RecoveryGroupModel>(
      RecoveryGroupModel.boxName,
      encryptionCipher: cipher,
    );
    return this;
  }
}
