import 'package:flutter/services.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'package:guardian_keyper/ui/theme/theme.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/ui/widgets/splash.dart';
import 'package:guardian_keyper/ui/utils/current_route_observer.dart';

import 'package:guardian_keyper/feature/settings/bloc/theme_mode_cubit.dart';

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
  Widget build(BuildContext context) => FutureBuilder(
        future: di.init(),
        builder: (context, state) => di.isNotInited
            ? const Splash()
            : BlocConsumer<ThemeModeCubit, ThemeMode>(
                bloc: GetIt.I<ThemeModeCubit>(),
                builder: (context, state) => MaterialApp(
                  title: 'Guardian Keyper',
                  routes: routes,
                  themeMode: state,
                  theme: themeLight,
                  darkTheme: themeDark,
                  debugShowCheckedModeBanner: false,
                  navigatorObservers: [
                    GetIt.I<SentryNavigatorObserver>(),
                    GetIt.I<CurrentRouteObserver>(),
                  ],
                  home: const Home(key: Key('AppHomeWidget')),
                ),
                listener: (context, state) {
                  SystemChrome.setSystemUIOverlayStyle(switch (state) {
                    ThemeMode.dark => systemStyleDark,
                    ThemeMode.light => systemStyleLight,
                    _ => MediaQuery.of(context).platformBrightness ==
                            Brightness.dark
                        ? systemStyleDark
                        : systemStyleLight,
                  });
                },
              ),
      );
}
