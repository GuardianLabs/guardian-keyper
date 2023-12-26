import 'package:guardian_keyper/feature/intro/ui/intro_screen.dart';
import 'package:guardian_keyper/feature/dev_panel/dev_panel_screen.dart';
import 'package:guardian_keyper/feature/settings/ui/settings_screen.dart';
import 'package:guardian_keyper/feature/vault/ui/_vault_show/vault_show_screen.dart';
import 'package:guardian_keyper/feature/vault/ui/_shard_show/shard_show_screen.dart';
import 'package:guardian_keyper/feature/vault/ui/_vault_create/vault_create_screen.dart';
import 'package:guardian_keyper/feature/vault/ui/_secret_add/vault_secret_add_screen.dart';
import 'package:guardian_keyper/feature/vault/ui/_vault_restore/vault_restore_screen.dart';
import 'package:guardian_keyper/feature/vault/ui/_guardian_add/vault_guardian_add_screen.dart';
import 'package:guardian_keyper/feature/vault/ui/_secret_recovery/vault_secret_recovery_screen.dart';

const routeIntro = '/intro';
const routeSettings = '/settings';
const routeVaultShow = '/vault/show';
const routeVaultCreate = '/vault/create';
const routeVaultRestore = '/vault/restore';
const routeShardShow = '/vault/shard/show';
const routeVaultSecretAdd = '/vault/secret/add';
const routeVaultGuardianAdd = '/vault/guardian/add';
const routeVaultSecretRecovery = '/vault/secret/recovery';
const routeDevPanel = DevPanelScreen.route;

final routes = {
  routeIntro: (_) => const IntroScreen(),
  routeDevPanel: (_) => const DevPanelScreen(),
  routeSettings: (_) => const SettingsScreen(),
  routeShardShow: (_) => const ShardShowScreen(),
  routeVaultShow: (_) => const VaultShowScreen(),
  routeVaultCreate: (_) => const VaultCreateScreen(),
  routeVaultRestore: (_) => const VaultRestoreScreen(),
  routeVaultSecretAdd: (_) => const VaultSecretAddScreen(),
  routeVaultGuardianAdd: (_) => const VaultGuardianAddScreen(),
  routeVaultSecretRecovery: (_) => const VaultSecretRecoveryScreen(),
};
