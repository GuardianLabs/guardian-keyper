import 'package:get_it/get_it.dart';

import 'package:guardian_keyper/feature/vault/data/vault_repository.dart';
import 'package:guardian_keyper/feature/settings/data/settings_manager.dart';
import 'package:guardian_keyper/feature/settings/domain/settings_interactor.dart';
import 'package:guardian_keyper/feature/message/data/message_repository.dart';
import 'package:guardian_keyper/feature/message/domain/message_interactor.dart';
import 'package:guardian_keyper/feature/vault/domain/vault_interactor.dart';

import '../data/mdns_manager.dart';
import '../data/network_manager.dart';
import '../data/platform_manager.dart';
import '../data/analytics_manager.dart';
import '../data/preferences_manager.dart';
import '../domain/entity/env.dart';

class DI {
  static bool _isInited = false;

  const DI();

  Future<bool> init() async {
    if (_isInited) return true;

    // Independent Managers
    GetIt.I.registerSingleton<Env>(const Env());
    GetIt.I.registerSingleton<PlatformManager>(PlatformManager());
    GetIt.I.registerSingleton<PreferencesManager>(const PreferencesManager());
    GetIt.I.registerSingleton<AnalyticsManager>(await AnalyticsManager.init());

    // Managers depends on ^
    GetIt.I.registerSingleton<NetworkManager>(
      await NetworkManager().init(),
    );
    GetIt.I.registerSingleton<SettingsManager>(
      await SettingsManager().init(),
    );
    GetIt.I.registerSingleton<MdnsManager>(
      await MdnsManager(router: GetIt.I<NetworkManager>().router).init(),
    );

    // Repositories
    await Hive.initFlutter('data_v1');
    GetIt.I.registerSingleton<MessageRepository>(await getMessageRepository());
    GetIt.I.registerSingleton<VaultRepository>(await getVaultRepository());

    // Interactors
    GetIt.I.registerSingleton<SettingsInteractor>(SettingsInteractor());
    GetIt.I.registerSingleton<MessageInteractor>(MessageInteractor());
    GetIt.I.registerSingleton<VaultInteractor>(VaultInteractor());

    return _isInited = true;
  }
}
