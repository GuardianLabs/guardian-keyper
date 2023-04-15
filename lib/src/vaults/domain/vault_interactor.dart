import 'package:get_it/get_it.dart';

import 'package:guardian_keyper/src/core/domain/core_model.dart';
import 'package:guardian_keyper/src/core/data/network_manager.dart';
import 'package:guardian_keyper/src/core/data/platform_gateway.dart';
import 'package:guardian_keyper/src/core/data/analytics_gateway.dart';
import 'package:guardian_keyper/src/settings/data/settings_manager.dart';

import '../data/vault_repository.dart';

class VaultInteractor {
  VaultInteractor({
    NetworkManager? networkService,
    PlatformGateway? platformGateway,
    AnalyticsGateway? analyticsGateway,
    SettingsManager? settingsManager,
    VaultRepository? vaultRepository,
  })  : _networkService = networkService ?? GetIt.I<NetworkManager>(),
        _platformGateway = platformGateway ?? GetIt.I<PlatformGateway>(),
        _analyticsGateway = analyticsGateway ?? GetIt.I<AnalyticsGateway>(),
        _vaultRepository = vaultRepository ?? GetIt.I<VaultRepository>(),
        _settingsManager = settingsManager ?? GetIt.I<SettingsManager>();

  late final myPeerId = _networkService.myPeerId.copyWith(
    name: _settingsManager.deviceName,
  );
  late final requestRetryPeriod = _networkService.messageTTL;

  late final vibrate = _platformGateway.vibrate;
  late final wakelockEnable = _platformGateway.wakelockEnable;
  late final wakelockDisable = _platformGateway.wakelockDisable;
  late final localAuthenticate = _platformGateway.localAuthenticate;

  Stream<MessageModel> get messageStream => _networkService.messageStream;

  String get passCode => _settingsManager.passCode;

  bool get useBiometrics =>
      _settingsManager.hasBiometrics && _settingsManager.isBiometricsEnabled;

  final NetworkManager _networkService;
  final PlatformGateway _platformGateway;
  final AnalyticsGateway _analyticsGateway;
  final SettingsManager _settingsManager;
  final VaultRepository _vaultRepository;

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
      _networkService.sendTo(
        isConfirmable: false,
        peerId: message.peerId,
        message: message.copyWith(peerId: myPeerId),
      );

  Future<void> logStartCreateVault() =>
      _analyticsGateway.logEvent(eventStartCreateVault);

  Future<void> logFinishCreateVault() =>
      _analyticsGateway.logEvent(eventFinishCreateVault);

  Future<void> logStartAddGuardian() =>
      _analyticsGateway.logEvent(eventStartAddGuardian);

  Future<void> logFinishAddGuardian() =>
      _analyticsGateway.logEvent(eventFinishAddGuardian);

  Future<void> logStartRestoreVault() =>
      _analyticsGateway.logEvent(eventStartRestoreVault);

  Future<void> logFinishRestoreVault() =>
      _analyticsGateway.logEvent(eventFinishRestoreVault);

  Future<void> logStartAddSecret() =>
      _analyticsGateway.logEvent(eventStartAddSecret);

  Future<void> logFinishAddSecret() =>
      _analyticsGateway.logEvent(eventFinishAddSecret);

  Future<void> logStartRestoreSecret() =>
      _analyticsGateway.logEvent(eventStartRestoreSecret);

  Future<void> logFinishRestoreSecret() =>
      _analyticsGateway.logEvent(eventFinishRestoreSecret);
}
