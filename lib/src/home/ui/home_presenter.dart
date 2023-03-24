import 'dart:async';

import '/src/core/service/service_root.dart';
import '/src/core/repository/repository_root.dart';
import '/src/core/controller/page_controller_base.dart';

export 'package:provider/provider.dart';

export '/src/core/model/core_model.dart';

class HomePresenter extends PageControllerBase {
  late final share = _serviceRoot.platformService.share;
  late final wakelockEnable = _serviceRoot.platformService.wakelockEnable;
  late final wakelockDisable = _serviceRoot.platformService.wakelockDisable;

  PeerId get myPeerId => _myPeerId;

  Map<String, RecoveryGroupModel> get myVaults => _myVaults;
  Map<String, RecoveryGroupModel> get guardedVaults => _guardedVaults;

  HomePresenter({required super.pages}) {
    // cache Vaults
    for (final vault in _repositoryRoot.vaultRepository.values) {
      vault.ownerId == _myPeerId
          ? _myVaults[vault.aKey] = vault
          : _guardedVaults[vault.aKey] = vault;
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

  final _myVaults = <String, RecoveryGroupModel>{};
  final _guardedVaults = <String, RecoveryGroupModel>{};

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
  Future<MessageModel> createTakeVaultCode(final GroupId? groupId) async {
    final message = MessageModel(code: MessageCode.takeGroup, peerId: myPeerId);
    await _repositoryRoot.messageRepository.put(
      message.aKey,
      message.copyWith(payload: RecoveryGroupModel(id: groupId)),
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
      _guardedVaults.remove(event.key as String);
      _myVaults.remove(event.key as String);
    } else {
      final vault = event.value as RecoveryGroupModel;
      vault.ownerId == myPeerId
          ? _myVaults[vault.aKey] = vault
          : _guardedVaults[vault.aKey] = vault;
    }
    notifyListeners();
  }
}
