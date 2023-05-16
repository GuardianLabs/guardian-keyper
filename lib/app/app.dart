import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'package:guardian_keyper/ui/theme/theme.dart';
import 'package:guardian_keyper/ui/screens/splash_screen.dart';
import 'package:guardian_keyper/feature/home/ui/home_screen.dart';

import 'di.dart';
import 'theme.dart';
import 'routes.dart';

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
  Widget build(BuildContext context) => MaterialApp(
        title: 'Guardian Keyper',
        color: clIndigo900,
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
