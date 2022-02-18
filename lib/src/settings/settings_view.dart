import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/widgets/common.dart';

import 'settings_controller.dart';
import 'widgets/app_version.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({Key? key}) : super(key: key);

  static const routeName = '/settings';

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<SettingsController>(context);
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          const HeaderBar(caption: 'Settings'),
          // Version
          const Padding(
            padding: EdgeInsets.all(20),
            child: AppVersionWidget(),
          ),
          // Theme
          Padding(
            padding: const EdgeInsets.all(20),
            child: DropdownButton<ThemeMode>(
              value: controller.themeMode,
              onChanged: null,
              // onChanged: controller.updateThemeMode,
              items: const [
                DropdownMenuItem(
                  value: ThemeMode.system,
                  child: Text('System Theme'),
                ),
                DropdownMenuItem(
                  value: ThemeMode.light,
                  child: Text('Light Theme'),
                ),
                DropdownMenuItem(
                  value: ThemeMode.dark,
                  child: Text('Dark Theme'),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: ElevatedButton(
              child: const Text('Delete all groups'),
              onPressed: controller.clearRecoveryGroups,
            ),
          ),
          // Footer
          Expanded(child: Container()),
        ],
      ),
    );
  }
}
