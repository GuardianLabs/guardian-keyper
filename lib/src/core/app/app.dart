import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'package:guardian_keyper/src/home/ui/home_screen.dart';

import '../ui/theme/theme.dart';
import '../ui/widgets/init_loader.dart';
import 'app_lifecycle_observer.dart';
import 'routes.dart';
import 'di.dart';

class App extends StatelessWidget {
  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setSystemUIOverlayStyle(systemStyleDark);
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  const App({super.key, this.di = const DI()});

  final DI di;

  @override
  Widget build(final BuildContext context) => FutureBuilder<bool>(
        future: di.init(),
        builder: (
          final BuildContext context,
          final AsyncSnapshot<bool> snapshot,
        ) =>
            snapshot.data == null
                ? MaterialApp(
                    home: const InitLoader(),
                    theme: themeLight,
                    darkTheme: themeDark,
                    themeMode: ThemeMode.dark,
                  )
                : MaterialApp(
                    title: 'Guardian Keyper',
                    theme: themeLight,
                    darkTheme: themeDark,
                    themeMode: ThemeMode.dark,
                    onGenerateRoute: onGenerateRoute,
                    navigatorObservers: [SentryNavigatorObserver()],
                    home: const AppLifecycleObserver(child: HomeScreen()),
                  ),
      );
}
