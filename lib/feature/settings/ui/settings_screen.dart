import 'package:flutter/foundation.dart';

import 'package:guardian_keyper/app/routes.dart';
import 'package:guardian_keyper/ui/presenters/settings_presenter.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/ui/widgets/icon_of.dart';
import 'package:guardian_keyper/data/managers/auth_manager.dart';
import 'package:guardian_keyper/feature/message/ui/widgets/requests_icon.dart';
import 'package:guardian_keyper/feature/auth/ui/dialogs/on_change_pass_code_dialog.dart';

import 'dialogs/on_set_device_name_dialog.dart';
import 'widgets/theme_mode_switcher.dart';

class SettingsScreen extends StatelessWidget {
  static const route = '/settings';

  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authManager = GetIt.I<AuthManager>();
    final settingsPresenter = context.read<SettingsPresenter>();
    final bgColor = Theme.of(context).colorScheme.secondary;
    return ScaffoldSafe(
      isSeparated: true,
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      children: [
        // Change Device Name
        Selector<SettingsPresenter, String>(
            builder: (context, value, child) => ListTile(
                  leading: IconOf.user(bgColor: bgColor),
                  title: const Text('Rename device'),
                  subtitle: Text(value),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded),
                  onTap: () => OnSetDeviceNameDialog.show(context),
                ),
            selector: (context, value) => value.name),
        // Change PassCode
        ListTile(
          leading: IconOf.passcode(bgColor: bgColor),
          title: const Text('Change passcode'),
          subtitle: const Text('Set new authentication passcode'),
          trailing: const Icon(Icons.arrow_forward_ios_rounded),
          onTap: () => OnChangePassCodeDialog.show(context),
        ),
        // Toggle Biometrics
        if (authManager.hasBiometrics)
          StreamBuilder<bool>(
            stream: authManager.state.map((e) => e.isBiometricsEnabled),
            builder: (context, snapshot) => SwitchListTile.adaptive(
              secondary: const Icon(Icons.fingerprint, size: 40),
              title: const Text('Biometric login'),
              subtitle: const Text(
                'Easier, faster authentication with biometry',
              ),
              value: snapshot.data ?? authManager.isBiometricsEnabled,
              onChanged: authManager.setIsBiometricsEnabled,
            ),
          ),
        // Toggle Bootstrap
        Selector<SettingsPresenter, bool>(
            builder: (context, value, child) => SwitchListTile.adaptive(
                  secondary: IconOf.connection(bgColor: bgColor),
                  title: const Text('Proxy connection'),
                  subtitle: const Text(
                    'P2P-discovery via Internet',
                  ),
                  value: value,
                  onChanged: settingsPresenter.setIsBootstrapEnabled,
                ),
            selector: (context, value) => value.isBootstrapEnabled),
        // Show Requests Archive
        ListTile(
          leading: const RequestsIcon(
            isSelected: false,
            iconSize: IconOf.defaultIconSize,
          ),
          title: const Text('Requests'),
          subtitle: const Text('Show requests history'),
          trailing: const Icon(Icons.arrow_forward_ios_rounded),
          onTap: () => Navigator.pushNamed(context, routeRequestsScreen),
        ),
        // Theme Mode Switcher
        if (kDebugMode) const ThemeModeSwitcher(),
      ],
    );
  }
}
