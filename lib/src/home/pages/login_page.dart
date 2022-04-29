import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/src/settings/settings_controller.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settingsController = Provider.of<SettingsController>(context);
    return Center(
      child: ElevatedButton(
        child: const Text('Unlock'),
        onPressed: () => settingsController.isLocked = false,
      ),
    );
  }
}
