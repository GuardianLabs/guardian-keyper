import 'package:flutter/material.dart';

import '/src/intro/ui/intro_screen.dart';
import '/src/message/ui/qr_code_screen.dart';
import '/src/settings/ui/settings_screen.dart';
import '/src/vaults/ui/edit/vault_edit_screen.dart';
import '/src/vaults/ui/create/vault_create_screen.dart';
import '/src/vaults/ui/add_secret/vault_add_secret_screen.dart';
import '/src/vaults/ui/restore/vault_restore_group_screen.dart';
import '/src/vaults/ui/add_guardian/vault_add_guardian_screen.dart';
import '/src/vaults/ui/recover_secret/vault_recover_secret_screen.dart';

Route? onGenerateRoute(final RouteSettings routeSettings) {
  switch (routeSettings.name) {
    // Vaults
    case VaultCreateScreen.routeName:
      return VaultCreateScreen.getPageRoute(routeSettings);
    case VaultEditScreen.routeName:
      return VaultEditScreen.getPageRoute(routeSettings);
    case VaultAddGuardianScreen.routeName:
      return VaultAddGuardianScreen.getPageRoute(routeSettings);
    case VaultAddSecretScreen.routeName:
      return VaultAddSecretScreen.getPageRoute(routeSettings);
    case VaultRecoverSecretScreen.routeName:
      return VaultRecoverSecretScreen.getPageRoute(routeSettings);
    case VaultRestoreGroupScreen.routeName:
      return VaultRestoreGroupScreen.getPageRoute(routeSettings);

    // Show QRCode
    case QRCodeScreen.routeName:
      return QRCodeScreen.getPageRoute(routeSettings);

    // Settings
    case SettingsScreen.routeName:
      return SettingsScreen.getPageRoute(routeSettings);

    // Intro
    case IntroScreen.routeName:
      return IntroScreen.getPageRoute(routeSettings);

    default:
      return null;
  }
}
