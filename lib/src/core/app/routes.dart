import 'package:flutter/material.dart';

import 'package:guardian_keyper/src/intro/ui/intro_screen.dart';
import 'package:guardian_keyper/src/settings/ui/settings_screen.dart';
import 'package:guardian_keyper/src/message/ui/show_qr_code_screen.dart';
import 'package:guardian_keyper/src/message/ui/scan_qr_code_screen.dart';
import 'package:guardian_keyper/src/vaults/ui/_vault/vault_screen.dart';
import 'package:guardian_keyper/src/vaults/ui/_dashboard/shard_screen.dart';
import 'package:guardian_keyper/src/vaults/ui/_vault_create/vault_create_screen.dart';
import 'package:guardian_keyper/src/vaults/ui/add_secret/vault_add_secret_screen.dart';
import 'package:guardian_keyper/src/vaults/ui/_vault_restore/vault_restore_screen.dart';
import 'package:guardian_keyper/src/vaults/ui/_guardian_add/vault_guardian_add_screen.dart';
import 'package:guardian_keyper/src/vaults/ui/recover_secret/vault_recover_secret_screen.dart';

Route? onGenerateRoute(final RouteSettings routeSettings) =>
    routes[routeSettings.name]?.call(routeSettings);

const routes = {
  IntroScreen.routeName: IntroScreen.getPageRoute,
  SettingsScreen.routeName: SettingsScreen.getPageRoute,
  // Shard
  ShardScreen.routeName: ShardScreen.getPageRoute,
  // QRCodes
  ShowQRCodeScreen.routeName: ShowQRCodeScreen.getPageRoute,
  ScanQRCodeScreen.routeName: ScanQRCodeScreen.getPageRoute,
  // Vaults
  VaultCreateScreen.routeName: VaultCreateScreen.getPageRoute,
  VaultScreen.routeName: VaultScreen.getPageRoute,
  VaultRestoreScreen.routeName: VaultRestoreScreen.getPageRoute,
  VaultGuardianAddScreen.routeName: VaultGuardianAddScreen.getPageRoute,
  // Secrets
  VaultAddSecretScreen.routeName: VaultAddSecretScreen.getPageRoute,
  VaultRecoverSecretScreen.routeName: VaultRecoverSecretScreen.getPageRoute,
};
