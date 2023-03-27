import 'package:flutter/material.dart';

import '/src/intro/ui/intro_screen.dart';
import '/src/settings/ui/settings_screen.dart';
import '/src/message/ui/show_qr_code_screen.dart';
import '/src/message/ui/scan_qr_code_screen.dart';
import '/src/vaults/ui/edit/vault_edit_screen.dart';
import '/src/vaults/ui/create/vault_create_screen.dart';
import '/src/vaults/ui/restore/vault_restore_screen.dart';
import '/src/vaults/ui/add_secret/vault_add_secret_screen.dart';
import '/src/vaults/ui/add_guardian/vault_add_guardian_screen.dart';
import '/src/vaults/ui/recover_secret/vault_recover_secret_screen.dart';

Route? onGenerateRoute(final RouteSettings routeSettings) {
  switch (routeSettings.name) {
    // Vaults
    case VaultCreateScreen.routeName:
      return VaultCreateScreen.getPageRoute(routeSettings);
    case VaultEditScreen.routeName:
      return VaultEditScreen.getPageRoute(routeSettings);
    case VaultRestoreScreen.routeName:
      return VaultRestoreScreen.getPageRoute(routeSettings);
    case VaultAddGuardianScreen.routeName:
      return VaultAddGuardianScreen.getPageRoute(routeSettings);
    // Secrets
    case VaultAddSecretScreen.routeName:
      return VaultAddSecretScreen.getPageRoute(routeSettings);
    case VaultRecoverSecretScreen.routeName:
      return VaultRecoverSecretScreen.getPageRoute(routeSettings);

    // Show QRCode
    case ShowQRCodeScreen.routeName:
      return ShowQRCodeScreen.getPageRoute(routeSettings);
    case ScanQRCodeScreen.routeName:
      return ScanQRCodeScreen.getPageRoute(routeSettings);

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
