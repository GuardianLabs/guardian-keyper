import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';

void main() async {
  final settingsController = SettingsController(SettingsService());

  FlutterNativeSplash.removeAfter((BuildContext context) async {
    await settingsController.loadSettings();
  });

  runApp(DIProvider(settingsController: settingsController));
}
