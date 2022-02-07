import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'theme_data.dart';
import 'intro/intro_view.dart';
import 'home/home_view.dart';
import 'wallet/wallet_select_view.dart';
import 'settings/settings_controller.dart';
import 'settings/settings_view.dart';

import 'recovery_group/recovery_group_model.dart';
import 'recovery_group/recovery_group_controller.dart';
import 'recovery_group/recovery_group_view.dart';
import 'recovery_group/create/recovery_group_create_view.dart';
import 'recovery_group/edit/recovery_group_edit_view.dart';

part 'di_provider.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final settingsController = Provider.of<SettingsController>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      restorationScopeId: 'app',
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // English, no country code
      ],
      onGenerateTitle: (BuildContext context) => 'Guardian Network',
      // AppLocalizations.of(context)!.appTitle,
      theme: theme,
      darkTheme: themeDark,
      themeMode: ThemeMode.dark,
      // themeMode: settingsController.themeMode,
      onGenerateRoute: (RouteSettings routeSettings) {
        return MaterialPageRoute<void>(
          settings: routeSettings,
          builder: (BuildContext context) {
            switch (routeSettings.name) {
              case IntroView.routeName:
                return const IntroView();
              case RecoveryGroupView.routeName:
                return const RecoveryGroupView();
              case RecoveryGroupCreateView.routeName:
                return const RecoveryGroupCreateView();
              case RecoveryGroupEditView.routeName:
                return RecoveryGroupEditView(
                    recoveryGroup:
                        routeSettings.arguments as RecoveryGroupModel);
              case WalletSelectView.routeName:
                return const WalletSelectView();
              case SettingsView.routeName:
                return const SettingsView();
              case HomeView.routeName:
              default:
                return const HomeView();
            }
          },
        );
      },
    );
  }
}
