import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'settings_controller.dart';
import '../recovery_group/recovery_group_controller.dart';

import '../core/widgets/common.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({Key? key}) : super(key: key);

  static const routeName = '/settings';

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<SettingsController>(context);
    final recoveryGroupscontroller =
        Provider.of<RecoveryGroupController>(context);
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          const HeaderBar(caption: 'Settings'),
          // Version
          Padding(
            padding: const EdgeInsets.all(20),
            child: FutureBuilder(
              future: PackageInfo.fromPlatform(),
              builder: ((context, AsyncSnapshot<PackageInfo?> snapshot) => Text(
                  '${snapshot.data?.version}+${snapshot.data?.buildNumber}')),
            ),
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
              onPressed: recoveryGroupscontroller.clear,
            ),
          ),
          // Footer
          Expanded(child: Container()),
        ],
      ),
    );
  }
}
