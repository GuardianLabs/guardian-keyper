import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'theme/theme.dart';
import 'di_container.dart';
import 'widgets/loader_widget.dart';
import '/src/guardian/guardian_controller.dart';

import 'routes.dart';

class App extends StatelessWidget {
  static Future<void> init() async {
    SystemChrome.setSystemUIOverlayStyle(systemStyleDark);
    await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp],
    );
  }

  final DIContainer diContainer;

  const App({super.key, required this.diContainer});

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          Provider.value(value: diContainer),
          Provider(
            create: (_) => GuardianController(diContainer: diContainer),
          ),
        ],
        child: MaterialApp(
          title: 'Guardian Keyper',
          debugShowCheckedModeBanner: false,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en', '')],
          theme: themeLight,
          darkTheme: themeDark,
          themeMode: ThemeMode.dark,
          home: const LoaderWidget(),
          onGenerateRoute: onGenerateRoute,
          navigatorObservers: [SentryNavigatorObserver()],
        ),
      );
}
