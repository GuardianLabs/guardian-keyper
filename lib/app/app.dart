import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'package:guardian_keyper/consts.dart';
import 'package:guardian_keyper/ui/theme/theme.dart';
import 'package:guardian_keyper/ui/widgets/splash.dart';
import 'package:guardian_keyper/data/services/platform_service.dart';
import 'package:guardian_keyper/data/services/analytics_service.dart';
import 'package:guardian_keyper/data/services/preferences_service.dart';

import 'package:guardian_keyper/feature/home/home.dart';
import 'package:guardian_keyper/feature/intro/ui/intro_screen.dart';
import 'package:guardian_keyper/feature/settings/ui/settings_screen.dart';
import 'package:guardian_keyper/feature/vault/ui/_vault_show/vault_show_screen.dart';
import 'package:guardian_keyper/feature/vault/ui/_shard_show/shard_show_screen.dart';
import 'package:guardian_keyper/feature/vault/ui/_vault_create/vault_create_screen.dart';
import 'package:guardian_keyper/feature/vault/ui/_secret_add/vault_secret_add_screen.dart';
import 'package:guardian_keyper/feature/vault/ui/_vault_restore/vault_restore_screen.dart';
import 'package:guardian_keyper/feature/vault/ui/_guardian_add/vault_guardian_add_screen.dart';
import 'package:guardian_keyper/feature/vault/ui/_secret_recovery/vault_secret_recovery_screen.dart';

import 'package:guardian_keyper/feature/auth/data/auth_manager.dart';
import 'package:guardian_keyper/feature/network/data/network_manager.dart';

import 'package:guardian_keyper/feature/vault/data/vault_repository.dart';
import 'package:guardian_keyper/feature/vault/domain/use_case/vault_interactor.dart';

import 'package:guardian_keyper/feature/message/data/message_repository.dart';
import 'package:guardian_keyper/feature/message/domain/use_case/message_interactor.dart';

class App extends StatelessWidget {
  static bool _isInited = false;

  const App({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Guardian Keyper',
        color: clIndigo900,
        darkTheme: themeDark,
        themeMode: ThemeMode.dark,
        debugShowCheckedModeBanner: false,
        navigatorObservers: [SentryNavigatorObserver()],
        home: FutureBuilder(
          future: _init(),
          builder: (context, state) =>
              _isInited ? const Home() : const Splash(),
        ),
        routes: {
          routeIntro: (_) => const IntroScreen(),
          routeSettings: (_) => const SettingsScreen(),
          routeShardShow: (_) => const ShardShowScreen(),
          routeVaultShow: (_) => const VaultShowScreen(),
          routeVaultCreate: (_) => const VaultCreateScreen(),
          routeVaultRestore: (_) => const VaultRestoreScreen(),
          routeVaultSecretAdd: (_) => const VaultSecretAddScreen(),
          routeVaultGuardianAdd: (_) => const VaultGuardianAddScreen(),
          routeVaultSecretRecovery: (_) => const VaultSecretRecoveryScreen(),
        },
      );

  Future<void> _init() async {
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
