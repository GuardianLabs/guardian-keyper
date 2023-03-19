import 'package:flutter/material.dart';

import '/src/core/model/core_model.dart';

import '/src/intro/intro_view.dart';
import '/src/settings/settings_screen.dart';
import '/src/recovery_group/edit_group/edit_group_view.dart';
import '/src/recovery_group/add_secret/add_secret_view.dart';
import '/src/recovery_group/create_group/create_group_view.dart';
import '/src/recovery_group/add_guardian/add_guardian_view.dart';
import '/src/recovery_group/restore_group/restore_group_view.dart';
import '/src/recovery_group/recover_secret/recover_secret_view.dart';

Route<dynamic>? onGenerateRoute(final RouteSettings routeSettings) {
  return MaterialPageRoute<void>(
    settings: routeSettings,
    builder: (final BuildContext context) {
      switch (routeSettings.name) {
        case IntroView.routeName:
          return const IntroView();

        case CreateGroupView.routeName:
          return const CreateGroupView();

        case EditGroupView.routeName:
          return EditGroupView(
            groupId: routeSettings.arguments as GroupId,
          );

        case AddGuardianView.routeName:
          return AddGuardianView(
            groupId: routeSettings.arguments as GroupId,
          );

        case AddSecretView.routeName:
          return AddSecretView(
            groupId: routeSettings.arguments as GroupId,
          );

        case RecoverSecretView.routeName:
          return RecoverSecretView(
            groupIdWithSecretId:
                routeSettings.arguments as MapEntry<GroupId, SecretId>,
          );

        case RestoreGroupView.routeName:
          return RestoreGroupView(
            skipExplainer: routeSettings.arguments as bool,
          );

        case SettingsScreen.routeName:
          return const SettingsScreen();
      }
      throw Exception('Route not found!');
    },
  );
}
