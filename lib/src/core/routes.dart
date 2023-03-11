import 'package:flutter/material.dart';

import 'model/core_model.dart';
import '../settings/settings_controller.dart';
import '/src/home/home_view.dart';
import '/src/intro/intro_view.dart';
import '/src/settings/settings_view.dart';
import '/src/recovery_group/add_secret/add_secret_view.dart';
import '/src/recovery_group/create_group/create_group_view.dart';
import '/src/recovery_group/add_guardian/add_guardian_view.dart';
import '/src/recovery_group/restore_group/restore_group_view.dart';
import '/src/recovery_group/edit_group/edit_group_view.dart';
import '/src/recovery_group/recover_secret/recover_secret_view.dart';

Route<dynamic>? onGenerateRoute(RouteSettings routeSettings) =>
    MaterialPageRoute<void>(
      settings: routeSettings,
      builder: (final BuildContext context) {
        if (GetIt.I<SettingsController>().state.passCode.isEmpty) {
          return const IntroView();
        }
        switch (routeSettings.name) {
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

          case SettingsView.routeName:
            return const SettingsView();
        }
        return const HomeView();
      },
    );
