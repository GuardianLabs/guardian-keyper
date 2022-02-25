import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'settings/settings_controller.dart';
import 'guardian/guardian_controller.dart';
import 'recovery_group/recovery_group_controller.dart';

import 'app.dart';

class DIProvider extends StatelessWidget {
  const DIProvider({
    Key? key,
    required this.settingsController,
    required this.guardianController,
    required this.recoveryGroupController,
  }) : super(key: key);

  final SettingsController settingsController;
  final GuardianController guardianController;
  final RecoveryGroupController recoveryGroupController;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: settingsController),
        ChangeNotifierProvider.value(value: guardianController),
        ChangeNotifierProvider.value(value: recoveryGroupController),
      ],
      child: const App(),
    );
  }
}
