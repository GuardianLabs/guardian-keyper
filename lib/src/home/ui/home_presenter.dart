import 'dart:async';
import 'package:get_it/get_it.dart';

import '/src/core/data/platform_manager.dart';
import '/src/core/ui/page_presenter_base.dart';
import '/src/core/service/network/network_service.dart';
import '/src/settings/data/settings_repository.dart';
import '/src/message/data/message_repository.dart';
import '/src/vaults/data/vault_repository.dart';

export 'package:provider/provider.dart';

class HomePresenter extends PagePresenterBase {
  late final share = _platformManager.share;
  late final vibrate = _platformManager.vibrate;
  late final wakelockEnable = _platformManager.wakelockEnable;
  late final wakelockDisable = _platformManager.wakelockDisable;
  late final localAuthenticate = _platformManager.localAuthenticate;
  late final startNetwork = _networkService.start;
  late final pauseNetwork = _networkService.pause;
  late final stopNetwork = _networkService.stop;

  PeerId get myPeerId => _myPeerId;

  bool get hasBiometrics => _platformManager.hasBiometrics;

  Map<VaultId, VaultModel> get myVaults => _myVaults;
  Map<VaultId, VaultModel> get guardedVaults => _guardedVaults;

  HomePresenter({required super.pages}) {
    // cache Vaults
    for (final vault in _vaultRepository.values) {
      vault.ownerId == _myPeerId
          ? _myVaults[vault.id] = vault
          : _guardedVaults[vault.id] = vault;
    }
    // subscribe to updates
    _vaultsUpdatesSubscription =
        _vaultRepository.watch().listen(_onVaultsUpdate);
    _settingsUpdatesSubscription =
        _settingsRepository.stream.listen(_onSettingsUpdate);
  }

  final _networkService = GetIt.I<NetworkService>();
  final _platformManager = GetIt.I<PlatformManager>();
  final _vaultRepository = GetIt.I<VaultRepository>();
  final _messageRepository = GetIt.I<MessageRepository>();
  final _settingsRepository = GetIt.I<SettingsRepository>();

  late final StreamSubscription<BoxEvent> _vaultsUpdatesSubscription;
  late final StreamSubscription<SettingsEvent> _settingsUpdatesSubscription;

  final _myVaults = <VaultId, VaultModel>{};
  final _guardedVaults = <VaultId, VaultModel>{};

  late var _myPeerId = _networkService.myPeerId.copyWith(
    name: _settingsRepository.settings.deviceName,
  );

  @override
  void dispose() async {
    await _vaultsUpdatesSubscription.cancel();
    await _settingsUpdatesSubscription.cancel();
    super.dispose();
  }

  /// Create ticket to join vault
  Future<MessageModel> createJoinVaultCode() async {
    final message = MessageModel(
      code: MessageCode.createGroup,
      peerId: myPeerId,
    );
    await _messageRepository.put(message.aKey, message);
    return message;
  }

  /// Create ticket to take vault
  Future<MessageModel> createTakeVaultCode(final VaultId? groupId) async {
    final message = MessageModel(code: MessageCode.takeGroup, peerId: myPeerId);
    await _messageRepository.put(
      message.aKey,
      message.copyWith(payload: VaultModel(id: groupId)),
    );
    return message;
  }

  void _onSettingsUpdate(final SettingsEvent event) {
    if (event.key == SettingsRepositoryKeys.deviceName) {
      _myPeerId = _myPeerId.copyWith(name: event.value.deviceName);
      notifyListeners();
    }
  }

  void _onVaultsUpdate(final BoxEvent event) {
    if (event.deleted) {
      _myVaults.removeWhere((_, v) => v.aKey == event.key);
      _guardedVaults.removeWhere((_, v) => v.aKey == event.key);
    } else {
      final vault = event.value as VaultModel;
      vault.ownerId == myPeerId
          ? _myVaults[vault.id] = vault
          : _guardedVaults[vault.id] = vault;
    }
    notifyListeners();
  }
}
