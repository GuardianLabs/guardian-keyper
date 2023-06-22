import 'package:get_it/get_it.dart';
import 'package:flutter/foundation.dart';

import 'package:guardian_keyper/data/services/platform_service.dart';
import 'package:guardian_keyper/feature/network/data/network_manager.dart';
import 'package:guardian_keyper/feature/network/domain/entity/peer_id.dart';
import 'package:guardian_keyper/feature/vault/domain/use_case/vault_interactor.dart';
import 'package:guardian_keyper/feature/message/domain/use_case/message_interactor.dart';

export 'package:provider/provider.dart';

class DashboardPresenter extends ChangeNotifier {
  DashboardPresenter() {
    // cache Vaults and Shards
    for (final vault in _vaultInteractor.vaults) {
      vault.ownerId == _networkManager.selfId
          ? _vaults.add(vault.aKey)
          : _shards.add(vault.aKey);
    }
    // init subscriptions
    _settingsChanges.resume();
    _vaultChanges.resume();
  }

  @override
  void dispose() {
    _settingsChanges.cancel();
    _vaultChanges.cancel();
    super.dispose();
  }

  late final share = _platformService.share;
  late final createJoinVaultCode = _messagesInteractor.createJoinVaultCode;

  int get vaultsCount => _vaults.length;
  int get shardsCount => _shards.length;

  PeerId get selfId => _networkManager.selfId;

  final _vaults = <String>{};
  final _shards = <String>{};

  final _platformService = GetIt.I<PlatformService>();
  final _networkManager = GetIt.I<NetworkManager>();
  final _vaultInteractor = GetIt.I<VaultInteractor>();
  final _messagesInteractor = GetIt.I<MessageInteractor>();

  late final _settingsChanges = _networkManager.state.listen((event) {
    if (event.peerId.name != _deviceName) {
      _deviceName = event.peerId.name;
      notifyListeners();
    }
  });

  late final _vaultChanges = _vaultInteractor.watch().listen((event) {
    if (event.isDeleted) {
      _vaults.remove(event.key);
      _shards.remove(event.key);
    } else {
      event.vault!.ownerId == _networkManager.selfId
          ? _vaults.add(event.vault!.aKey)
          : _shards.add(event.vault!.aKey);
    }
    notifyListeners();
  });

  late String _deviceName = _networkManager.selfId.name;
}
