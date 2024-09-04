import 'package:get_it/get_it.dart';
import 'package:flutter/services.dart';
import 'package:guardian_keyper/data/repositories/settings_repository.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'package:guardian_keyper/ui/theme/theme.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/ui/widgets/splash.dart';
import 'package:guardian_keyper/ui/utils/current_route_observer.dart';
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
        if (di.isNotInited) return const Splash();

        return MultiProvider(
          providers: [
            ChangeNotifierProvider<SettingsPresenter>(
              create: (_) => SettingsPresenter(),
            ),
          ],
          child: Selector<SettingsPresenter, ThemeMode>(
            selector: (_, p) => p.themeMode,
            builder: (context, themeMode, _) {
              SystemChrome.setSystemUIOverlayStyle(switch (themeMode) {
                ThemeMode.dark => systemStyleDark,
                ThemeMode.light => systemStyleLight,
                ThemeMode.system =>
                  MediaQuery.of(context).platformBrightness == Brightness.dark
                      ? systemStyleDark
                      : systemStyleLight,
              });
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Guardian Keyper',
                routes: routes,
                themeMode: themeMode,
                theme: lightTheme,
                darkTheme: darkTheme,
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
