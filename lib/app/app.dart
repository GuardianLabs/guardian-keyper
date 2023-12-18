import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'package:guardian_keyper/ui/theme/theme.dart';
import 'package:guardian_keyper/ui/widgets/splash.dart';
import 'package:guardian_keyper/feature/home/ui/home_screen.dart';

import 'di.dart';
import 'routes.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Guardian Keyper',
        theme: themeLight,
        darkTheme: themeDark,
        themeMode: ThemeMode.dark,
        debugShowCheckedModeBanner: false,
        navigatorObservers: [SentryNavigatorObserver()],
        home: FutureBuilder(
          future: DI.init(),
          builder: (context, state) =>
              DI.isInited ? const HomeScreen() : const Splash(),
        ),
        routes: routes,
      );
}
