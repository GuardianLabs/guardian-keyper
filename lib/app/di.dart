import 'dart:typed_data';
import 'package:hive/hive.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'package:guardian_keyper/ui/utils/current_route_observer.dart';
import 'package:guardian_keyper/data/services/platform_service.dart';
import 'package:guardian_keyper/data/services/analytics_service.dart';
import 'package:guardian_keyper/data/services/preferences_service.dart';
import 'package:guardian_keyper/data/repositories/settings_repository.dart';

import 'package:guardian_keyper/feature/auth/data/auth_manager.dart';
import 'package:guardian_keyper/feature/network/data/network_manager.dart';

import 'package:guardian_keyper/feature/vault/data/vault_repository.dart';
import 'package:guardian_keyper/feature/vault/domain/use_case/vault_interactor.dart';

import 'package:guardian_keyper/feature/message/data/message_repository.dart';
import 'package:guardian_keyper/feature/message/domain/use_case/message_interactor.dart';

class DI {
  static bool _isInited = false;

  const DI();

  bool get isInited => _isInited;
  bool get isNotInited => !_isInited;

  Future<void> init() async {
    if (_isInited) return;

    // Services
    final preferences = await PreferencesService().init();
    GetIt.I.registerSingleton<PreferencesService>(preferences);
    GetIt.I.registerSingleton<PlatformService>(PlatformService());
    GetIt.I.registerSingleton<SentryNavigatorObserver>(
      SentryNavigatorObserver(),
    );
    GetIt.I.registerSingleton<CurrentRouteObserver>(
      CurrentRouteObserver(),
    );
    GetIt.I.registerSingleton<AnalyticsService>(
      await AnalyticsService.init(),
    );

    // Managers
    GetIt.I.registerSingleton<AuthManager>(
      await AuthManager().init(),
      dispose: (s) => s.dispose(),
    );
    GetIt.I.registerSingleton<NetworkManager>(
      await NetworkManager().init(),
      dispose: (s) => s.dispose(),
    );

    // Repositories
    final encryptionCipher = HiveAesCipher(
      (await preferences.get<Uint8List>(PreferencesKeys.keySeed))!,
    );
    Hive.init(preferences.pathDataDir);
    GetIt.I.registerSingleton<SettingsRepository>(
      await SettingsRepository().init(),
      dispose: (s) => s.dispose(),
    );
    GetIt.I.registerSingleton<VaultRepository>(
      await VaultRepository().init(
        encryptionCipher: encryptionCipher,
      ),
      dispose: (s) => s.dispose(),
    );
    GetIt.I.registerSingleton<MessageRepository>(
      await MessageRepository().init(
        encryptionCipher: encryptionCipher,
      ),
      dispose: (s) => s.dispose(),
    );

    // Interactors
    GetIt.I.registerSingleton<MessageInteractor>(
      MessageInteractor(),
      dispose: (s) => s.dispose(),
    );
    GetIt.I.registerSingleton<VaultInteractor>(
      VaultInteractor(),
    );

    _isInited = true;
  }
}
