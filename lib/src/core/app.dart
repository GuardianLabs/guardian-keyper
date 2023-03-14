import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '/src/loader/loader_widget.dart';
import 'theme/theme.dart';
import 'routes.dart';

class App extends StatelessWidget {
  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setSystemUIOverlayStyle(systemStyleDark);
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  const App({super.key});

  @override
  Widget build(final BuildContext context) => MaterialApp(
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
      );
}
