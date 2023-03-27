import 'dart:async';

import '/src/core/data/repository_root.dart';
import '/src/core/service/service_root.dart';
import '/src/core/ui/page_presenter_base.dart';

export 'package:provider/provider.dart';

export '/src/core/data/core_model.dart';

class HomePresenter extends PagePresenterBase {
  late final share = _serviceRoot.platformService.share;
  late final wakelockEnable = _serviceRoot.platformService.wakelockEnable;
  late final wakelockDisable = _serviceRoot.platformService.wakelockDisable;

  PeerId get myPeerId => _myPeerId;

  Map<VaultId, VaultModel> get myVaults => _myVaults;
  Map<VaultId, VaultModel> get guardedVaults => _guardedVaults;

  HomePresenter({required super.pages}) {
    // cache Vaults
    for (final vault in _repositoryRoot.vaultRepository.values) {
      vault.ownerId == _myPeerId
          ? _myVaults[vault.id] = vault
          : _guardedVaults[vault.id] = vault;
    }
    // subscribe to updates
    _vaultsUpdatesSubscription =
        _repositoryRoot.vaultRepository.watch().listen(_onVaultsUpdate);
    _settingsUpdatesSubscription =
        _repositoryRoot.settingsRepository.stream.listen(_onSettingsUpdate);
  }

  final _serviceRoot = GetIt.I<ServiceRoot>();
  final _repositoryRoot = GetIt.I<RepositoryRoot>();

  late final StreamSubscription<BoxEvent> _vaultsUpdatesSubscription;
  late final StreamSubscription<MapEntry> _settingsUpdatesSubscription;

  final _myVaults = <VaultId, VaultModel>{};
  final _guardedVaults = <VaultId, VaultModel>{};

  late var _myPeerId = PeerId(
    token: _serviceRoot.networkService.myId,
    name: _repositoryRoot.settingsRepository.deviceName,
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
    await _repositoryRoot.messageRepository.put(message.aKey, message);
    return message;
  }

  /// Create ticket to take vault
  Future<MessageModel> createTakeVaultCode(final VaultId? groupId) async {
    final message = MessageModel(code: MessageCode.takeGroup, peerId: myPeerId);
    await _repositoryRoot.messageRepository.put(
      message.aKey,
      message.copyWith(payload: VaultModel(id: groupId)),
    );
    return message;
  }

  void _onSettingsUpdate(final MapEntry event) {
    if (event.key == SettingsRepositoryKeys.deviceName) {
      _myPeerId = _myPeerId.copyWith(name: event.value as String);
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
