import 'package:get_it/get_it.dart';

import 'package:guardian_keyper/data/network_manager.dart';
import 'package:guardian_keyper/data/platform_service.dart';
import 'package:guardian_keyper/data/analytics_service.dart';
import 'package:guardian_keyper/domain/entity/_id/peer_id.dart';
import 'package:guardian_keyper/domain/entity/_id/secret_id.dart';
import 'package:guardian_keyper/domain/entity/_id/vault_id.dart';
import 'package:guardian_keyper/domain/entity/message_model.dart';
import 'package:guardian_keyper/domain/entity/vault_model.dart';
import 'package:guardian_keyper/feature/settings/data/settings_manager.dart';

import '../data/vault_repository.dart';

typedef VaultEvent = ({String key, VaultModel? vault, bool isDeleted});

class VaultInteractor {
  late final flush = _vaultRepository.flush;
  late final pingPeer = _networkManager.pingPeer;
  late final getPeerStatus = _networkManager.getPeerStatus;
  late final requestRetryPeriod = _networkManager.messageTTL;

  late final vibrate = _platformManager.vibrate;
  late final openMarket = _platformManager.openMarket;
  late final wakelockEnable = _platformManager.wakelockEnable;
  late final wakelockDisable = _platformManager.wakelockDisable;
  late final localAuthenticate = _platformManager.localAuthenticate;

  late final logStartCreateVault = _analyticsManager.logStartCreateVault;
  late final logFinishCreateVault = _analyticsManager.logFinishCreateVault;
  late final logStartAddGuardian = _analyticsManager.logStartAddGuardian;
  late final logFinishAddGuardian = _analyticsManager.logFinishAddGuardian;
  late final logStartRestoreVault = _analyticsManager.logStartRestoreVault;
  late final logFinishRestoreVault = _analyticsManager.logFinishRestoreVault;
  late final logStartAddSecret = _analyticsManager.logStartAddSecret;
  late final logFinishAddSecret = _analyticsManager.logFinishAddSecret;
  late final logStartRestoreSecret = _analyticsManager.logStartRestoreSecret;
  late final logFinishRestoreSecret = _analyticsManager.logFinishRestoreSecret;

  PeerId get selfId => _settingsManager.selfId;

  String get passCode => _settingsManager.passCode;

  Iterable<VaultModel> get vaults => _vaultRepository.values;

  Stream<MessageModel> get messageStream => _networkManager.messageStream;

  Stream<(PeerId, bool)> get peerStatusChangeStream =>
      _networkManager.peerStatusChangeStream;

  bool get useBiometrics =>
      _settingsManager.hasBiometrics && _settingsManager.isBiometricsEnabled;

  Stream<VaultEvent> watch([String? key]) =>
      _vaultRepository.watch(key: key).map<VaultEvent>((e) => (
            key: e.key as String,
            vault: e.value as VaultModel?,
            isDeleted: e.deleted,
          ));

  VaultModel? getVaultById(VaultId vaultId) =>
      _vaultRepository.get(vaultId.asKey);

  Future<VaultModel> createVault(VaultModel vault) async {
    await _vaultRepository.put(vault.aKey, vault);
    return vault;
  }

  Future<VaultId> removeVault(VaultId vaultId) async {
    await _vaultRepository.delete(vaultId.asKey);
    return vaultId;
  }

  Future<VaultModel> addGuardian({
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
    required VaultModel vault,
    required SecretId secretId,
    required String secretValue,
  }) =>
      _vaultRepository.put(
        vault.aKey,
        vault.copyWith(secrets: {...vault.secrets, secretId: secretValue}),
      );

  Future<void> removeSecret({
    required VaultModel vault,
    required SecretId secretId,
  }) async {
    vault.secrets.remove(secretId);
    await _vaultRepository.put(vault.aKey, vault);
  }

  Future<void> sendToGuardian(MessageModel message) => _networkManager.sendTo(
        message.peerId,
        isConfirmable: false,
        message: message.copyWith(peerId: _settingsManager.selfId),
      );

  final _networkManager = GetIt.I<NetworkManager>();
  final _platformManager = GetIt.I<PlatformService>();
  final _settingsManager = GetIt.I<SettingsManager>();
  final _analyticsManager = GetIt.I<AnalyticsService>();
  final _vaultRepository = GetIt.I<VaultRepository>();
}
