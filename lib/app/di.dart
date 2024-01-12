import 'dart:typed_data';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'package:guardian_keyper/data/services/platform_service.dart';
import 'package:guardian_keyper/data/services/analytics_service.dart';
import 'package:guardian_keyper/data/repositories/settings_repository.dart';
import 'package:guardian_keyper/ui/utils/current_route_observer.dart';

import 'package:guardian_keyper/data/managers/auth_manager.dart';
import 'package:guardian_keyper/data/managers/network_manager.dart';

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
    final pathAppDir = (await getApplicationDocumentsDirectory()).path;

    // Register Service Layer
    GetIt.I.registerLazySingleton<PlatformService>(PlatformService.new);
    GetIt.I.registerLazySingleton<SentryNavigatorObserver>(
      SentryNavigatorObserver.new,
    );
    GetIt.I.registerLazySingleton<CurrentRouteObserver>(
      CurrentRouteObserver.new,
    );
    GetIt.I.registerSingleton<AnalyticsService>(
      await AnalyticsService.init(),
    );

    // Register Data Layer
    final settingsRepository = await SettingsRepository().init(pathAppDir);
    GetIt.I.registerSingleton<SettingsRepository>(settingsRepository);

    GetIt.I.registerSingleton<NetworkManager>(
      await NetworkManager().init(),
      dispose: (i) => i.close(),
    );

    final encryptionCipher = HiveAesCipher(
      settingsRepository.get<Uint8List>(PreferencesKeys.keySeed)!,
    );
    Hive.init('$pathAppDir/data_v1');
    GetIt.I.registerSingleton<VaultRepository>(
      await VaultRepository().init(encryptionCipher: encryptionCipher),
      dispose: (i) => i.close(),
    );
    GetIt.I.registerSingleton<MessageRepository>(
      await MessageRepository().init(encryptionCipher: encryptionCipher),
      dispose: (i) => i.close(),
    );
    GetIt.I.registerSingleton<AuthManager>(
      await AuthManager().init(),
      dispose: (i) => i.close(),
    );

    // Register Domain Layer
    GetIt.I.registerLazySingleton<MessageInteractor>(
      MessageInteractor.new,
      dispose: (i) => i.close(),
    );
    GetIt.I.registerLazySingleton<VaultInteractor>(
      VaultInteractor.new,
    );

    _isInited = true;
  }
}
