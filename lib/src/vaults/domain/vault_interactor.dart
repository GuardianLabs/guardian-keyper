import 'package:get_it/get_it.dart';

import '/src/core/data/platform_manager.dart';
import '/src/core/service/network/network_service.dart';
import '/src/core/infrastructure/analytics_service.dart';
import '/src/settings/data/settings_repository.dart';
import '/src/vaults/data/vault_repository.dart';

class VaultInteractor {
  VaultInteractor({
    NetworkService? networkService,
    PlatformManager? platformManager,
    AnalyticsService? analyticsService,
    SettingsRepository? settingsRepository,
    VaultRepository? vaultRepository,
  })  : _networkService = networkService ?? GetIt.I<NetworkService>(),
        _platformManager = platformManager ?? GetIt.I<PlatformManager>(),
        _analyticsService = analyticsService ?? GetIt.I<AnalyticsService>(),
        _vaultRepository = vaultRepository ?? GetIt.I<VaultRepository>(),
        _settingsRepository =
            settingsRepository ?? GetIt.I<SettingsRepository>();

  late final myPeerId = _networkService.myPeerId.copyWith(
    name: _settingsRepository.settings.deviceName,
  );
  late final requestRetryPeriod = _networkService.messageTTL;

  late final vibrate = _platformManager.vibrate;
  late final wakelockEnable = _platformManager.wakelockEnable;
  late final wakelockDisable = _platformManager.wakelockDisable;
  late final localAuthenticate = _platformManager.localAuthenticate;

  Stream<MessageModel> get messageStream => _networkService.messageStream;

  String get passCode => _settingsRepository.settings.passCode;

  bool get useBiometrics =>
      _platformManager.hasBiometrics &&
      _settingsRepository.settings.isBiometricsEnabled;

  final NetworkService _networkService;
  final PlatformManager _platformManager;
  final AnalyticsService _analyticsService;
  final SettingsRepository _settingsRepository;
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
      _analyticsService.logEvent(eventStartCreateVault);

  Future<void> logFinishCreateVault() =>
      _analyticsService.logEvent(eventFinishCreateVault);

  Future<void> logStartAddGuardian() =>
      _analyticsService.logEvent(eventStartAddGuardian);

  Future<void> logFinishAddGuardian() =>
      _analyticsService.logEvent(eventFinishAddGuardian);

  Future<void> logStartRestoreVault() =>
      _analyticsService.logEvent(eventStartRestoreVault);

  Future<void> logFinishRestoreVault() =>
      _analyticsService.logEvent(eventFinishRestoreVault);

  Future<void> logStartAddSecret() =>
      _analyticsService.logEvent(eventStartAddSecret);

  Future<void> logFinishAddSecret() =>
      _analyticsService.logEvent(eventFinishAddSecret);

  Future<void> logStartRestoreSecret() =>
      _analyticsService.logEvent(eventStartRestoreSecret);

  Future<void> logFinishRestoreSecret() =>
      _analyticsService.logEvent(eventFinishRestoreSecret);
}
