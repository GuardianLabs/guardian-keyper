import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'di.dart';
import 'routes.dart';
import 'ui/home_screen.dart';
import 'ui/theme.dart';
import 'ui/splash_screen.dart';

class App extends StatelessWidget {
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
  Widget build(final BuildContext context) => MaterialApp(
        title: 'Guardian Keyper',
        theme: themeLight,
        darkTheme: themeDark,
        themeMode: ThemeMode.dark,
        onGenerateRoute: onGenerateRoute,
        navigatorObservers: [SentryNavigatorObserver()],
        home: FutureBuilder<DI>(
          future: di.init(),
          builder: (_, snapshot) =>
              snapshot.data == null ? const SplashScreen() : const HomeScreen(),
        ),
      );
}
