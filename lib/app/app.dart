import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'package:guardian_keyper/ui/theme/theme.dart';
import 'package:guardian_keyper/ui/widgets/splash.dart';
import 'package:guardian_keyper/ui/utils/theme_mode_mapper.dart';
import 'package:guardian_keyper/ui/utils/current_route_observer.dart';

import 'package:guardian_keyper/feature/settings/domain/use_case/settings_theme_case.dart';

import 'di.dart';
import 'routes.dart';
import 'lifecycler.dart';

class App extends StatelessWidget with ThemeModeMapper {
  const App({
    this.di = const DI(),
    super.key,
  });

  final DI di;

  @override
  Widget build(BuildContext context) => FutureBuilder(
        future: di.init(),
        builder: (context, state) => di.isNotInited
            // TBD: light color scheme
            ? const Splash(brightness: Brightness.dark)
            : StreamBuilder<ThemeMode>(
                // TBD: light color scheme
                // initialData: mapBoolToThemeMode(themeModeHandler.isDarkMode),
                initialData: ThemeMode.dark,
                stream: SettingsThemeCase()
                    .events
                    .map<ThemeMode>(mapBoolToThemeMode),
                builder: (context, snapshot) {
                  SystemChrome.setSystemUIOverlayStyle(switch (snapshot.data) {
                    ThemeMode.dark => systemStyleDark,
                    ThemeMode.light => systemStyleLight,
                    _ => MediaQuery.of(context).platformBrightness ==
                            Brightness.dark
                        ? systemStyleDark
                        : systemStyleLight,
                  });
                  return MaterialApp(
                    title: 'Guardian Keyper',
                    routes: routes,
                    theme: themeLight,
                    darkTheme: themeDark,
                    themeMode: snapshot.data,
                    debugShowCheckedModeBanner: false,
                    navigatorObservers: [
                      GetIt.I<SentryNavigatorObserver>(),
                      GetIt.I<CurrentRouteObserver>(),
                    ],
                    home: const Lifecycler(key: Key('AppLifecycler')),
                  );
                },
              ),
      );
}
