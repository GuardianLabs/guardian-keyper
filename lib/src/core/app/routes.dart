import 'package:flutter/material.dart';

import 'package:guardian_keyper/src/intro/ui/intro_screen.dart';
import 'package:guardian_keyper/src/settings/ui/settings_route.dart';
import 'package:guardian_keyper/src/message/ui/show_qr_code_screen.dart';
import 'package:guardian_keyper/src/message/ui/scan_qr_code_screen.dart';
import 'package:guardian_keyper/src/vaults/ui/edit/vault_edit_screen.dart';
import 'package:guardian_keyper/src/vaults/ui/create/vault_create_screen.dart';
import 'package:guardian_keyper/src/vaults/ui/restore/vault_restore_screen.dart';
import 'package:guardian_keyper/src/vaults/ui/add_secret/vault_add_secret_screen.dart';
import 'package:guardian_keyper/src/vaults/ui/add_guardian/vault_add_guardian_screen.dart';
import 'package:guardian_keyper/src/vaults/ui/recover_secret/vault_recover_secret_screen.dart';

Route? onGenerateRoute(final RouteSettings routeSettings) =>
    routes[routeSettings.name]?.call(routeSettings);

const routes = {
  IntroScreen.routeName: IntroScreen.getPageRoute,
  SettingsRoute.routeName: SettingsRoute.getPageRoute,
  // QRCodes
  ShowQRCodeScreen.routeName: ShowQRCodeScreen.getPageRoute,
  ScanQRCodeScreen.routeName: ScanQRCodeScreen.getPageRoute,
  // Vaults
  VaultCreateScreen.routeName: VaultCreateScreen.getPageRoute,
  VaultEditScreen.routeName: VaultEditScreen.getPageRoute,
  VaultRestoreScreen.routeName: VaultRestoreScreen.getPageRoute,
  VaultAddGuardianScreen.routeName: VaultAddGuardianScreen.getPageRoute,
  // Secrets
  VaultAddSecretScreen.routeName: VaultAddSecretScreen.getPageRoute,
  VaultRecoverSecretScreen.routeName: VaultRecoverSecretScreen.getPageRoute,
};
