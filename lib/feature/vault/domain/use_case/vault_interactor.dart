import 'package:guardian_keyper/feature/network/domain/entity/peer_id.dart';
import 'package:guardian_keyper/feature/vault/domain/entity/secret_id.dart';
import 'package:guardian_keyper/feature/vault/domain/entity/vault_id.dart';
import 'package:guardian_keyper/feature/vault/data/vault_repository.dart';

import 'vault_analytics_mixin.dart';
import 'vault_platform_mixin.dart';
import 'vault_network_mixin.dart';
import 'vault_sss_mixin.dart';

export 'package:get_it/get_it.dart';

export 'package:guardian_keyper/feature/vault/data/vault_repository.dart'
    show VaultRepositoryEvent;

/// Depends on:
/// [
///   PreferencesService,
///   AnalyticsService,
///   PlatformService,
///   VaultRepository,
///   NetworkManager,
/// ]
class VaultInteractor
    with
        VaultAnalyticsMixin,
        VaultSssMixin,
        VaultNetworkMixin,
        VaultPlatformMixin {
  final _vaultRepository = GetIt.I<VaultRepository>();

  Iterable<Vault> get vaults =>
      _vaultRepository.values.where((e) => e.ownerId == selfId);

  Iterable<Vault> get shards =>
      _vaultRepository.values.where((e) => e.ownerId != selfId);

  Stream<VaultRepositoryEvent> watch([String? key]) =>
      _vaultRepository.watch(key);

  Vault? getVaultById(VaultId vaultId) => _vaultRepository.get(vaultId.asKey);

  Future<Vault> createVault(Vault vault) async {
    await _vaultRepository.put(vault.aKey, vault);
    return vault;
  }

  Future<VaultId> removeVault(VaultId vaultId) async {
    await _vaultRepository.delete(vaultId.asKey);
    return vaultId;
  }

  Future<Vault> addGuardian({
    required VaultId vaultId,
    required PeerId guardian,
  }) async {
    var vault = _vaultRepository.get(vaultId.asKey)!;
    vault = vault.copyWith(
      guardians: {...vault.guardians, guardian: ''},
    );
    await _vaultRepository.put(vaultId.asKey, vault);
    return vault;
  }

  Future<void> addSecret({
    required Vault vault,
    required SecretId secretId,
    required String secretValue,
  }) =>
      _vaultRepository.put(
        vault.aKey,
        vault.copyWith(secrets: {...vault.secrets, secretId: secretValue}),
      );

  Future<void> removeSecret({
    required Vault vault,
    required SecretId secretId,
  }) async {
    vault.secrets.remove(secretId);
    await _vaultRepository.put(vault.aKey, vault);
  }

  Future<void> takeVaultOwnership(VaultId vaultId) => _vaultRepository.put(
        vaultId.asKey,
        _vaultRepository.get(vaultId.asKey)!.copyWith(
          ownerId: selfId,
          guardians: {selfId: ''},
        ),
      );
}
