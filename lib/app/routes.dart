import 'package:guardian_keyper/feature/intro/ui/intro_screen.dart';
import 'package:guardian_keyper/feature/settings/ui/settings_screen.dart';
import 'package:guardian_keyper/feature/onboarding/ui/onboarding_screen.dart';
import 'package:guardian_keyper/feature/vault/ui/_vault_show/vault_show_screen.dart';
import 'package:guardian_keyper/feature/vault/ui/_shard_show/shard_show_screen.dart';
import 'package:guardian_keyper/feature/vault/ui/_vault_create/vault_create_screen.dart';
import 'package:guardian_keyper/feature/vault/ui/_secret_add/vault_secret_add_screen.dart';
import 'package:guardian_keyper/feature/vault/ui/_vault_restore/vault_restore_screen.dart';
import 'package:guardian_keyper/feature/vault/ui/_guardian_add/vault_guardian_add_screen.dart';
import 'package:guardian_keyper/feature/vault/ui/_secret_recovery/vault_secret_recovery_screen.dart';

const routeIntro = IntroScreen.route;
const routeSettings = SettingsScreen.route;
const routeShardShow = ShardShowScreen.route;
const routeVaultShow = VaultShowScreen.route;
const routeVaultCreate = VaultCreateScreen.route;
const routeVaultRestore = VaultRestoreScreen.route;
const routeVaultSecretAdd = VaultSecretAddScreen.route;
const routeVaultGuardianAdd = VaultGuardianAddScreen.route;
const routeVaultSecretRecovery = VaultSecretRecoveryScreen.route;
const routeOnboarding = OnboardingScreen.route;

final routes = {
  IntroScreen.route: (_) => const IntroScreen(),
  SettingsScreen.route: (_) => const SettingsScreen(),
  ShardShowScreen.route: (_) => const ShardShowScreen(),
  VaultShowScreen.route: (_) => const VaultShowScreen(),
  VaultCreateScreen.route: (_) => const VaultCreateScreen(),
  VaultRestoreScreen.route: (_) => const VaultRestoreScreen(),
  VaultSecretAddScreen.route: (_) => const VaultSecretAddScreen(),
  VaultGuardianAddScreen.route: (_) => const VaultGuardianAddScreen(),
  VaultSecretRecoveryScreen.route: (_) => const VaultSecretRecoveryScreen(),
  OnboardingScreen.route: (_) => const OnboardingScreen(),
};
