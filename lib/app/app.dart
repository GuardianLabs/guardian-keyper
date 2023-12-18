import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'package:guardian_keyper/ui/theme/theme.dart';
import 'package:guardian_keyper/ui/widgets/splash.dart';

import 'package:guardian_keyper/feature/home/ui/home_screen.dart';
import 'package:guardian_keyper/ui/utils/theme_mode_mapper.dart';
import 'package:guardian_keyper/feature/settings/data/settings_repository.dart';
import 'package:guardian_keyper/feature/settings/domain/settings_repository_event.dart';

import 'di.dart';
import 'routes.dart';

class App extends StatelessWidget with ThemeModeMapper {
  const App({
    this.di = const DI(),
    super.key,
  });

  final DI di;

  @override
  Widget build(BuildContext context) => FutureBuilder(
        future: di.init(),
        builder: (context, state) {
          if (di.isNotInited) return const Splash();
          final sentryNavigatorObserver = SentryNavigatorObserver();
          final settingsRepository = GetIt.I<SettingsRepository>();
          return StreamBuilder<ThemeMode>(
            initialData: mapBoolToThemeMode(settingsRepository.isDarkMode),
            stream: settingsRepository.events
                .where((e) => e is SettingsRepositoryEventThemeMode)
                .map<ThemeMode>(
                  (e) => mapBoolToThemeMode(
                      (e as SettingsRepositoryEventThemeMode).isDarkModeOn),
                ),
            builder: (context, snapshot) => MaterialApp(
              title: 'Guardian Keyper',
              theme: themeLight,
              darkTheme: themeDark,
              themeMode: snapshot.data,
              debugShowCheckedModeBanner: false,
              navigatorObservers: [sentryNavigatorObserver],
              routes: routes,
              home: const HomeScreen(),
            ),
          );
        },
      );
}
