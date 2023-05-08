import 'package:flutter/material.dart';

import 'package:guardian_keyper/feature/intro/ui/intro_screen.dart';
import 'package:guardian_keyper/feature/settings/ui/settings_screen.dart';
import 'package:guardian_keyper/feature/qr_code/ui/qr_code_show_screen.dart';
import 'package:guardian_keyper/feature/qr_code/ui/qr_code_scan_screen.dart';
import 'package:guardian_keyper/feature/vault/ui/_vault_show/vault_show_screen.dart';
import 'package:guardian_keyper/feature/vault/ui/_shard_show/shard_show_screen.dart';
import 'package:guardian_keyper/feature/vault/ui/_vault_create/vault_create_screen.dart';
import 'package:guardian_keyper/feature/vault/ui/_secret_add/vault_secret_add_screen.dart';
import 'package:guardian_keyper/feature/vault/ui/_vault_restore/vault_restore_screen.dart';
import 'package:guardian_keyper/feature/vault/ui/_guardian_add/vault_guardian_add_screen.dart';
import 'package:guardian_keyper/feature/vault/ui/_secret_recovery/vault_secret_recovery_screen.dart';

const routeIntro = '/intro';
const routeSettings = '/settings';

const routeQrCodeShow = '/qrcode/show';
const routeQrCodeScan = '/qrcode/scan';

const routeShardShow = '/vault/shard/show';

const routeVaultShow = '/vault/show';
const routeVaultCreate = '/vault/create';
const routeVaultRestore = '/vault/restore';
const routeVaultAddGuardian = '/vault/guardian/add';

const routeVaultAddSecret = '/vault/secret/add';
const routeVaultRecoverSecret = '/vault/secret/recover';

Route? onGenerateRoute(final RouteSettings settings) {
  final screen = routes[settings.name];
  return screen == null
      ? null
      : MaterialPageRoute(
          fullscreenDialog: true,
          settings: settings,
          builder: (_) => screen,
        );
}

const routes = <String, Widget>{
  routeIntro: IntroScreen(),
  routeSettings: SettingsScreen(),
  // QRCode
  routeQrCodeShow: QRCodeShowScreen(),
  routeQrCodeScan: QRCodeScanScreen(),
  // Shard
  routeShardShow: ShardShowScreen(),
  // Vault
  routeVaultShow: VaultShowScreen(),
  routeVaultCreate: VaultCreateScreen(),
  routeVaultRestore: VaultRestoreScreen(),
  routeVaultAddGuardian: VaultGuardianAddScreen(),
  // Secret
  routeVaultAddSecret: VaultSecretAddScreen(),
  routeVaultRecoverSecret: VaultSecretRecoveryScreen(),
};
