import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';
import 'src/recovery_group/recovery_group_controller.dart';
import 'src/recovery_group/recovery_group_service.dart';

void main() async {
  final settingsController = SettingsController(SettingsService());
  final recoveryGroupController =
      RecoveryGroupController(RecoveryGroupService());

  FlutterNativeSplash.removeAfter((BuildContext context) async {
    await settingsController.load();
    await recoveryGroupController.load();
  });

  runApp(DIProvider(
    settingsController: settingsController,
    recoveryGroupController: recoveryGroupController,
  ));
}
