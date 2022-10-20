import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/theme/theme.dart';
import 'core/di_container.dart';
import 'guardian/guardian_controller.dart';

import 'routes.dart';

class App extends StatelessWidget {
  final DIContainer diContainer;

  const App({super.key, required this.diContainer});

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          Provider.value(value: diContainer),
          Provider(
            create: (_) => GuardianController(diContainer: diContainer),
            lazy: false,
          ),
        ],
        child: MaterialApp(
          title: 'Guardian Keyper',
          debugShowCheckedModeBanner: false,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en', '')],
          theme: themeDark,
          darkTheme: themeDark,
          themeMode: ThemeMode.dark,
          onGenerateRoute: onGenerateRoute,
          navigatorObservers: [SentryNavigatorObserver()],
        ),
      );
}
