import 'package:flutter/material.dart';

import 'package:guardian_keyper/consts.dart';
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

Route? onGenerateRoute(RouteSettings settings) => MaterialPageRoute(
      settings: settings,
      fullscreenDialog: true,
      builder: (_) => switch (settings.name) {
        routeIntro => const IntroScreen(),
        routeSettings => const SettingsScreen(),
        // QRCode
        routeQrCodeShow => const QRCodeShowScreen(),
        routeQrCodeScan => const QRCodeScanScreen(),
        // Shard
        routeShardShow => const ShardShowScreen(),
        // Vault
        routeVaultShow => const VaultShowScreen(),
        routeVaultCreate => const VaultCreateScreen(),
        routeVaultRestore => const VaultRestoreScreen(),
        routeVaultGuardianAdd => const VaultGuardianAddScreen(),
        // Secret
        routeVaultSecretAdd => const VaultSecretAddScreen(),
        routeVaultSecretRecovery => const VaultSecretRecoveryScreen(),
        // null
        _ => throw Exception('Route not found!'),
      },
    );
