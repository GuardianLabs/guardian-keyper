import 'package:get_it/get_it.dart';

import 'package:guardian_keyper/src/core/domain/entity/core_model.dart';
import 'package:guardian_keyper/src/core/data/network_manager.dart';
import 'package:guardian_keyper/src/core/data/platform_manager.dart';
import 'package:guardian_keyper/src/core/data/analytics_manager.dart';
import 'package:guardian_keyper/src/settings/data/settings_manager.dart';

import '../data/vault_repository.dart';

class VaultInteractor {
  late final myPeerId = _networkManager.myPeerId.copyWith(
    name: _settingsManager.deviceName,
  );
  late final requestRetryPeriod = _networkManager.messageTTL;

  late final vibrate = _platformManager.vibrate;
  late final wakelockEnable = _platformManager.wakelockEnable;
  late final wakelockDisable = _platformManager.wakelockDisable;
  late final localAuthenticate = _platformManager.localAuthenticate;

  Stream<MessageModel> get messageStream => _networkManager.messageStream;

  String get passCode => _settingsManager.passCode;

  bool get useBiometrics =>
      _settingsManager.hasBiometrics && _settingsManager.isBiometricsEnabled;

  final _networkManager = GetIt.I<NetworkManager>();
  final _platformManager = GetIt.I<PlatformManager>();
  final _settingsManager = GetIt.I<SettingsManager>();
  final _analyticsManager = GetIt.I<AnalyticsManager>();
  final _vaultRepository = GetIt.I<VaultRepository>();

  VaultModel? getVaultById(final VaultId vaultId) =>
      _vaultRepository.get(vaultId.asKey);

  Future<VaultModel> createGroup(final VaultModel vault) async {
    await _vaultRepository.put(vault.aKey, vault);
    return vault;
  }

  Future<VaultModel> addGuardian(
    final VaultId vaultId,
    final PeerId guardian,
  ) async {
    var vault = _vaultRepository.get(vaultId.asKey)!;
    vault = vault.copyWith(
      guardians: {...vault.guardians, guardian: ''},
    );
    await _vaultRepository.put(vaultId.asKey, vault);
    return vault;
  }

  Future<void> addSecret({
    required final VaultModel vault,
    required final SecretId secretId,
    required final String secretValue,
  }) =>
      _vaultRepository.put(
        vault.aKey,
        vault.copyWith(secrets: {...vault.secrets, secretId: secretValue}),
      );

  Future<void> sendToGuardian(final MessageModel message) =>
      _networkManager.sendTo(
        isConfirmable: false,
        peerId: message.peerId,
        message: message.copyWith(peerId: myPeerId),
      );

  Future<void> logStartCreateVault() =>
      _analyticsManager.logEvent(eventStartCreateVault);

  Future<void> logFinishCreateVault() =>
      _analyticsManager.logEvent(eventFinishCreateVault);

  Future<void> logStartAddGuardian() =>
      _analyticsManager.logEvent(eventStartAddGuardian);

  Future<void> logFinishAddGuardian() =>
      _analyticsManager.logEvent(eventFinishAddGuardian);

  Future<void> logStartRestoreVault() =>
      _analyticsManager.logEvent(eventStartRestoreVault);

  Future<void> logFinishRestoreVault() =>
      _analyticsManager.logEvent(eventFinishRestoreVault);

  Future<void> logStartAddSecret() =>
      _analyticsManager.logEvent(eventStartAddSecret);

  Future<void> logFinishAddSecret() =>
      _analyticsManager.logEvent(eventFinishAddSecret);

  Future<void> logStartRestoreSecret() =>
      _analyticsManager.logEvent(eventStartRestoreSecret);

  Future<void> logFinishRestoreSecret() =>
      _analyticsManager.logEvent(eventFinishRestoreSecret);
}
