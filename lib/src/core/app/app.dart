import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '/src/core/ui/theme/theme.dart';
import '/src/core/ui/widgets/init_loader.dart';

import '/src/home/ui/home_screen.dart';
import '/src/home/ui/home_presenter.dart';
import '/src/message/ui/message_presenter.dart';
import '/src/settings/ui/settings_presenter.dart';

import 'di.dart';
import 'routes.dart';

class App extends StatelessWidget {
  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setSystemUIOverlayStyle(systemStyleDark);
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  const App({super.key});

  @override
  Widget build(final BuildContext context) => FutureBuilder<bool>(
        future: DI.init(),
        builder: (final context, final snapshot) => snapshot.data == null
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
                    lazy: false,
                  ),
                  ChangeNotifierProvider<MessagesPresenter>(
                    create: (_) => MessagesPresenter(),
                    lazy: false,
                  ),
                  ChangeNotifierProvider<HomePresenter>(
                    create: (_) => HomePresenter(pages: HomeScreen.pages),
                    lazy: false,
                  ),
                ],
                child: MaterialApp(
                  title: 'Guardian Keyper',
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
