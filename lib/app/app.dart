import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:get_it/get_it.dart';

import 'package:guardian_keyper/ui/theme/theme.dart';
import 'package:guardian_keyper/ui/screens/splash_screen.dart';
import 'package:guardian_keyper/feature/home/ui/home_screen.dart';

import 'package:guardian_keyper/data/mdns_manager.dart';
import 'package:guardian_keyper/data/network_manager.dart';
import 'package:guardian_keyper/data/platform_service.dart';
import 'package:guardian_keyper/feature/vault/domain/use_case/vault_interactor.dart';
import 'package:guardian_keyper/feature/message/domain/use_case/message_interactor.dart';

import 'di.dart';
import 'theme.dart';
import 'routes.dart';

class App extends StatefulWidget {
  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setSystemUIOverlayStyle(systemStyleDark);
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  const App({
    super.key,
    this.di = const DI(),
  });

  final DI di;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    widget.di.init().then((_) => setState(() {}));
  }

  @override
  void didChangeAppLifecycleState(state) async {
    super.didChangeAppLifecycleState(state);
    if (kDebugMode) print(state);
    switch (state) {
      case AppLifecycleState.resumed:
        await _networkManager.start();
        await _mdnsManager.start();
        break;
      case AppLifecycleState.paused:
        _mdnsManager.pause();
        _networkManager.pause();
        // TBD: move to NetworkInteractor
        _platformService.wakelockDisable();
        await _vaultInteractor.pause();
        await _messagesInteractor.pause();
        break;
      default:
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _mdnsManager.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Guardian Keyper',
        color: clIndigo900,
        theme: themeLight,
        darkTheme: themeDark,
        themeMode: ThemeMode.dark,
        onGenerateRoute: onGenerateRoute,
        navigatorObservers: [SentryNavigatorObserver()],
        home: widget.di.isInited ? const HomeScreen() : const SplashScreen(),
      );

  // Private
  late final _mdnsManager = GetIt.I<MdnsManager>();
  late final _networkManager = GetIt.I<NetworkManager>();
  late final _platformService = GetIt.I<PlatformService>();
  late final _vaultInteractor = GetIt.I<VaultInteractor>();
  late final _messagesInteractor = GetIt.I<MessageInteractor>();
}
