import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'src/di_provider.dart';
import 'src/core/service/event_bus.dart';
import 'src/core/service/kv_storage.dart';

import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';
import 'src/recovery_group/recovery_group_controller.dart';
import 'src/recovery_group/recovery_group_service.dart';
import 'package:p2plib/p2plib.dart';

void main() async {
  await P2PCrypto().init();

  final eventBus = EventBus();
  final kvStrorage = KVStorage();
  final settingsController =
      SettingsController(SettingsService(kvStrorage), eventBus);
  final recoveryGroupController =
      RecoveryGroupController(RecoveryGroupService(kvStrorage), eventBus);

  FlutterNativeSplash.removeAfter((BuildContext context) async {
    await settingsController.load();
    await recoveryGroupController.load();
  });

  runApp(DIProvider(
    settingsController: settingsController,
    recoveryGroupController: recoveryGroupController,
  ));
}
