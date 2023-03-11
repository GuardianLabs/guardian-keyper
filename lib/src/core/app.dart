import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'theme/theme.dart';
import 'di_container.dart';
import 'model/core_model.dart';
import 'widgets/loader_widget.dart';
import 'service/platform_service.dart';
import 'service/analytics_service.dart';

import '/src/auth/auth_controller.dart';
import '/src/guardian/guardian_controller.dart';
import '/src/settings/settings_repository.dart';

import 'routes.dart';

class App extends StatelessWidget {
  static const globals = Globals();

  static late final DIContainer diContainer;

  static Future<void> init([final DIContainer? diContainer]) async {
    App.diContainer = diContainer ?? DIContainer();
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setSystemUIOverlayStyle(systemStyleDark);
    await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp],
    );
    GetIt.I.registerSingleton<Globals>(globals);
    GetIt.I.registerSingleton<DIContainer>(App.diContainer);
    GetIt.I.registerSingleton<PlatformService>(const PlatformService());
    GetIt.I.registerSingleton<AnalyticsService>(
      await AnalyticsService.init(globals.amplitudeKey),
    );
    GetIt.I.registerSingleton<SettingsRepository>(const SettingsRepository());
  }

  const App({super.key});

  @override
  Widget build(final BuildContext context) => MultiProvider(
        providers: [
          Provider.value(value: diContainer),
          Provider(create: (_) => const AuthController()),
          Provider(create: (_) => GuardianController()),
        ],
        child: MaterialApp(
          title: 'Guardian Keyper',
          debugShowCheckedModeBanner: false,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en', '')],
          theme: themeLight,
          darkTheme: themeDark,
          themeMode: ThemeMode.dark,
          home: const LoaderWidget(),
          onGenerateRoute: onGenerateRoute,
          navigatorObservers: [SentryNavigatorObserver()],
        ),
      );
}
