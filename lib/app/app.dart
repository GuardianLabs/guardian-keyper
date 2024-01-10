import 'package:flutter/services.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'package:guardian_keyper/consts.dart';
import 'package:guardian_keyper/ui/theme/theme.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/ui/widgets/splash.dart';
import 'package:guardian_keyper/ui/utils/current_route_observer.dart';
import 'package:guardian_keyper/data/repositories/settings_repository.dart';

import 'package:guardian_keyper/feature/home/ui/home_screen.dart';
import 'package:guardian_keyper/feature/home/ui/home_presenter.dart';

import 'di.dart';
import 'home.dart';
import 'routes.dart';

class App extends StatelessWidget {
  const App({
    this.di = const DI(),
    super.key,
  });

  final DI di;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: di.init(),
      builder: (context, _) {
        if (di.isNotInited) return const Splash();
        final settingsRepository = GetIt.I<SettingsRepository>();
        return StreamBuilder(
          initialData: settingsRepository.get<bool>(
            PreferencesKeys.keyIsDarkModeOn,
            // TBD: `true` for Keyper (2), `false` for Wallet (3), `null` for system
            !buildV3,
          ),
          stream: settingsRepository
              .watch<bool>(PreferencesKeys.keyIsDarkModeOn)
              .map((event) => event.value),
          builder: (context, snapshot) {
            final themeMode = switch (snapshot.data) {
              true => ThemeMode.dark,
              false => ThemeMode.light,
              null => ThemeMode.system,
            };
            SystemChrome.setSystemUIOverlayStyle(switch (themeMode) {
              ThemeMode.dark => systemStyleDark,
              ThemeMode.light => systemStyleLight,
              _ => MediaQuery.of(context).platformBrightness == Brightness.dark
                  ? systemStyleDark
                  : systemStyleLight,
            });
            return MaterialApp(
              title: 'Guardian Keyper',
              routes: routes,
              themeMode: themeMode,
              theme: themeLight,
              darkTheme: themeDark,
              debugShowCheckedModeBanner: false,
              navigatorObservers: [
                GetIt.I<SentryNavigatorObserver>(),
                GetIt.I<CurrentRouteObserver>(),
              ],
              builder: (context, child) => ChangeNotifierProvider(
                create: (_) => HomePresenter(stepsCount: HomeScreen.tabsCount),
                child: child,
              ),
              home: const Home(),
            );
          },
        );
      },
    );
  }
}
