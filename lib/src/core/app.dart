import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '/src/core/di.dart';
import '/src/core/routes.dart';
import '/src/core/ui/theme/theme.dart';
import 'ui/widgets/init_loader.dart';

import '/src/home/ui/home_screen.dart';
import '/src/home/ui/home_presenter.dart';
import '/src/message/ui/message_presenter.dart';
import '/src/settings/ui/settings_presenter.dart';

class App extends StatelessWidget {
  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setSystemUIOverlayStyle(systemStyleDark);
    // await SystemChrome.setEnabledSystemUIMode(
    //   SystemUiMode.manual,
    //   overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top],
    // );
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  const App({super.key});

  @override
  Widget build(final BuildContext context) => FutureBuilder<bool>(
        future: DI.init(),
        builder: (context, snapshot) => snapshot.data == null
            ? MaterialApp(
                home: const InitLoader(),
                theme: themeLight,
                darkTheme: themeDark,
                themeMode: ThemeMode.dark,
              )
            : MultiProvider(
                providers: [
                  ChangeNotifierProvider<SettingsPresenter>(
                    create: (_) => SettingsPresenter(),
                  ),
                  ChangeNotifierProvider<MessagesPresenter>(
                    create: (_) => MessagesPresenter(),
                  ),
                  ChangeNotifierProvider<HomePresenter>(
                    create: (_) => HomePresenter(pages: HomeScreen.pages),
                  ),
                ],
                child: MaterialApp(
                  title: 'Guardian Keyper',
                  supportedLocales: const [Locale('en', '')],
                  localizationsDelegates: const [
                    AppLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  theme: themeLight,
                  darkTheme: themeDark,
                  themeMode: ThemeMode.dark,
                  onGenerateRoute: onGenerateRoute,
                  navigatorObservers: [SentryNavigatorObserver()],
                  home: const HomeScreen(),
                ),
              ),
      );
}
