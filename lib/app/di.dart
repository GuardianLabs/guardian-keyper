import 'dart:typed_data';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:guardian_keyper/feature/auth/domain/auth_interactor.dart';

import 'package:guardian_keyper/feature/vault/data/vault_repository.dart';
import 'package:guardian_keyper/feature/vault/domain/use_case/vault_interactor.dart';

import 'package:guardian_keyper/feature/message/data/message_repository.dart';
import 'package:guardian_keyper/feature/message/domain/use_case/message_interactor.dart';

import 'package:guardian_keyper/feature/settings/data/settings_manager.dart';
import 'package:guardian_keyper/feature/settings/domain/settings_interactor.dart';

import '../data/network_manager.dart';
import '../data/services/platform_service.dart';
import '../data/services/analytics_service.dart';
import '../data/services/preferences_service.dart';

class DI {
  static bool _isInited = false;

  const DI();

  bool get isInited => _isInited;

  bool get isNotInited => !_isInited;

  Future<void> init() async {
    if (_isInited) return;

    // Services
    GetIt.I.registerSingleton<PlatformService>(PlatformService());
    final preferencesService = PreferencesService();
    GetIt.I.registerSingleton<PreferencesService>(preferencesService);
    GetIt.I.registerSingleton<AnalyticsService>(await AnalyticsService.init());

    // Managers
    GetIt.I.registerSingleton<NetworkManager>(
      await NetworkManager().init(),
    );
    GetIt.I.registerSingleton<SettingsManager>(
      await SettingsManager().init(),
    );

    // Repositories
    await Hive.initFlutter('data_v1');
    final seed = await preferencesService.get<Uint8List>(keySeed);
    final cipher = HiveAesCipher(seed!);
    GetIt.I.registerSingleton<MessageRepository>(
      await getMessageRepository(cipher),
    );
    GetIt.I.registerSingleton<VaultRepository>(
      await getVaultRepository(cipher),
    );

    // Interactors
    GetIt.I.registerSingleton<SettingsInteractor>(SettingsInteractor());
    GetIt.I.registerSingleton<MessageInteractor>(MessageInteractor());
    GetIt.I.registerSingleton<VaultInteractor>(VaultInteractor());
    GetIt.I.registerSingleton<AuthInteractor>(AuthInteractor());

    _isInited = true;
  }
}
