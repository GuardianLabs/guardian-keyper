import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/theme_data.dart';
import 'core/di_container.dart';
import 'core/model/core_model.dart';

import 'start_view.dart';
import 'home/home_view.dart';
import 'guardian/guardian_controller.dart';
import 'recovery_group/add_secret/add_secret_view.dart';
import 'recovery_group/create_group/create_group_view.dart';
import 'recovery_group/add_guardian/add_guardian_view.dart';
import 'recovery_group/restore_group/restore_group_view.dart';
import 'recovery_group/edit_group/recovery_group_edit_view.dart';
import 'recovery_group/recovery_secret/recovery_secret_view.dart';

class App extends StatelessWidget {
  final DIContainer diContainer;

  const App({super.key, required this.diContainer});

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          Provider.value(value: diContainer),
          ChangeNotifierProvider(
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
          theme: themeLight,
          darkTheme: themeDark,
          themeMode: ThemeMode.dark,
          onGenerateRoute: _onGenerateRoute,
          navigatorObservers: [SentryNavigatorObserver()],
        ),
      );

  Route<dynamic>? _onGenerateRoute(RouteSettings routeSettings) =>
      MaterialPageRoute<void>(
        settings: routeSettings,
        builder: (BuildContext context) {
          switch (routeSettings.name) {
            case HomeView.routeName:
              return const HomeView();

            case CreateGroupView.routeName:
              return const CreateGroupView();

            case RecoveryGroupEditView.routeName:
              return RecoveryGroupEditView(
                  groupId: routeSettings.arguments as GroupId);

            case AddGuardianView.routeName:
              return AddGuardianView(
                  groupId: routeSettings.arguments as GroupId);

            case RecoveryGroupAddSecretView.routeName:
              return RecoveryGroupAddSecretView(
                  groupId: routeSettings.arguments as GroupId);

            case RecoveryGroupRecoverySecretView.routeName:
              return RecoveryGroupRecoverySecretView(
                  groupId: routeSettings.arguments as GroupId);

            case RestoreGroupView.routeName:
              return const RestoreGroupView();

            default:
              return const StartView();
          }
        },
      );
}
