import 'package:flutter/material.dart';

import 'data/core_model.dart';

import '/src/intro/intro_view.dart';
import '/src/message/ui/qr_code_screen.dart';
import '/src/settings/ui/settings_screen.dart';
import '/src/recovery_group/add_secret/add_secret_view.dart';
import '/src/recovery_group/create_group/create_group_view.dart';
import '/src/recovery_group/add_guardian/add_guardian_view.dart';
import '/src/recovery_group/edit_vault/ui/edit_vault_screen.dart';
import '/src/recovery_group/restore_group/restore_group_view.dart';
import '/src/recovery_group/recover_secret/recover_secret_view.dart';

Route? onGenerateRoute(final RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case QRCodeScreen.routeName:
      return QRCodeScreen.getPageRoute(routeSettings);

    case EditVaultScreen.routeName:
      return EditVaultScreen.getPageRoute(routeSettings);

    case SettingsScreen.routeName:
      return SettingsScreen.getPageRoute(routeSettings);
  }
  return MaterialPageRoute<void>(
    settings: routeSettings,
    builder: (final BuildContext context) {
      switch (routeSettings.name) {
        case CreateGroupView.routeName:
          return const CreateGroupView();

        case AddGuardianView.routeName:
          return AddGuardianView(
            groupId: routeSettings.arguments as VaultId,
          );

        case AddSecretView.routeName:
          return AddSecretView(
            groupId: routeSettings.arguments as VaultId,
          );

        case RecoverSecretView.routeName:
          return RecoverSecretView(
            groupIdWithSecretId:
                routeSettings.arguments as MapEntry<VaultId, SecretId>,
          );

        case RestoreGroupView.routeName:
          return RestoreGroupView(
            skipExplainer: routeSettings.arguments as bool,
          );

        case SettingsScreen.routeName:
          return const SettingsScreen();

        case IntroView.routeName:
          return const IntroView();
      }
      throw Exception('Route not found!');
    },
  );
}
