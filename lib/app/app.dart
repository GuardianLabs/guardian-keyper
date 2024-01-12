import 'package:get_it/get_it.dart';
import 'package:flutter/services.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'package:guardian_keyper/ui/theme/theme.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/ui/widgets/splash.dart';
import 'package:guardian_keyper/ui/utils/current_route_observer.dart';
import 'package:guardian_keyper/ui/presenters/home_tab_presenter.dart';
import 'package:guardian_keyper/ui/presenters/settings_presenter.dart';

import 'package:guardian_keyper/feature/home/ui/home_screen.dart';
import 'package:guardian_keyper/feature/message/ui/request_handler.dart';

import 'di.dart';
import 'routes.dart';
import 'lifecycle.dart';

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
        // TBD: light color scheme
        if (di.isNotInited) return const Splash(brightness: Brightness.dark);
        return MultiProvider(
          providers: [
            ChangeNotifierProvider<SettingsPresenter>(
              create: (_) => SettingsPresenter(),
            ),
            ChangeNotifierProvider<HomeTabPresenter>(
              create: (_) => HomeTabPresenter(
                stepsCount: HomeScreen.tabsCount,
              ),
            ),
          ],
          child: Selector<SettingsPresenter, bool?>(
            selector: (_, p) => p.isDarkModeOn,
            builder: (context, isDarkModeOn, _) {
              SystemChrome.setSystemUIOverlayStyle(switch (isDarkModeOn) {
                true => systemStyleDark,
                false => systemStyleLight,
                null =>
                  MediaQuery.of(context).platformBrightness == Brightness.dark
                      ? systemStyleDark
                      : systemStyleLight,
              });
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Guardian Keyper',
                routes: routes,
                themeMode: switch (isDarkModeOn) {
                  true => ThemeMode.dark,
                  false => ThemeMode.light,
                  null => ThemeMode.system,
                },
                theme: themeLight,
                darkTheme: themeDark,
                themeAnimationCurve: Curves.bounceInOut,
                themeAnimationDuration: const Duration(seconds: 1),
                navigatorObservers: [
                  GetIt.I<SentryNavigatorObserver>(),
                  GetIt.I<CurrentRouteObserver>(),
                ],
                home: const Lifecycle(
                  child: RequestHandler(
                    child: HomeScreen(),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
