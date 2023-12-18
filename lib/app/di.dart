import 'package:get_it/get_it.dart';

import 'package:guardian_keyper/data/services/platform_service.dart';
import 'package:guardian_keyper/data/services/analytics_service.dart';
import 'package:guardian_keyper/data/services/preferences_service.dart';

import 'package:guardian_keyper/feature/auth/data/auth_manager.dart';
import 'package:guardian_keyper/feature/network/data/network_manager.dart';

import 'package:guardian_keyper/feature/vault/data/vault_repository.dart';
import 'package:guardian_keyper/feature/vault/domain/use_case/vault_interactor.dart';

import 'package:guardian_keyper/feature/message/data/message_repository.dart';
import 'package:guardian_keyper/feature/message/domain/use_case/message_interactor.dart';

abstract final class DI {
  static bool _isInited = false;

  static bool get isInited => _isInited;

  static Future<void> init() async {
    if (_isInited) return;

    // Services
    GetIt.I.registerSingleton<PreferencesService>(
      await PreferencesService().init(),
    );
    GetIt.I.registerSingleton<PlatformService>(PlatformService());
    GetIt.I.registerSingleton<AnalyticsService>(await AnalyticsService.init());
    // Managers
    GetIt.I.registerSingleton<AuthManager>(await AuthManager().init());
    GetIt.I.registerSingleton<NetworkManager>(await NetworkManager().init());
    // Repositories
    GetIt.I.registerSingleton<VaultRepository>(await VaultRepository().init());
    GetIt.I.registerSingleton<MessageRepository>(
      await MessageRepository().init(),
    );
    // Interactors
    GetIt.I.registerSingleton<MessageInteractor>(MessageInteractor());
    GetIt.I.registerSingleton<VaultInteractor>(VaultInteractor());

    _isInited = true;
  }
}
