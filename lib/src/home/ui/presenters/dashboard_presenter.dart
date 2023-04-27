import 'package:get_it/get_it.dart';
import 'package:flutter/foundation.dart';

import 'package:guardian_keyper/src/core/data/platform_manager.dart';
import 'package:guardian_keyper/src/core/data/preferences_manager.dart';
import 'package:guardian_keyper/src/core/domain/entity/core_model.dart';
import 'package:guardian_keyper/src/vaults/domain/vault_interactor.dart';
import 'package:guardian_keyper/src/message/domain/messages_interactor.dart';
import 'package:guardian_keyper/src/settings/domain/settings_interactor.dart';

export 'package:provider/provider.dart';

class DashboardPresenter extends ChangeNotifier {
  DashboardPresenter() {
    // cache Vaults and Shards
    for (final vault in _vaultInteractor.vaults) {
      vault.ownerId == _settingsInteractor.selfId
          ? _vaults.add(vault.id)
          : _shards.add(vault.id);
    }
    // init subscriptions
    _vaultsUpdatesSubscription.resume();
    _settingsUpdatesSubscription.resume();
  }

  late final share = _platformManager.share;
  late final createJoinVaultCode = _messagesInteractor.createJoinVaultCode;

  int get vaultsCount => _vaults.length;
  int get shardsCount => _shards.length;

  PeerId get selfId => _settingsInteractor.selfId;

  @override
  void dispose() {
    _settingsUpdatesSubscription.cancel();
    _vaultsUpdatesSubscription.cancel();
    super.dispose();
  }

  final _platformManager = GetIt.I<PlatformManager>();
  final _vaultInteractor = GetIt.I<VaultInteractor>();
  final _messagesInteractor = GetIt.I<MessagesInteractor>();
  final _settingsInteractor = GetIt.I<SettingsInteractor>();

  final _vaults = <VaultId>{};
  final _shards = <VaultId>{};

  late final _settingsUpdatesSubscription = _settingsInteractor.settingsChanges
      .listen((final MapEntry<String, Object> event) {
    if (event.key == keyDeviceName) notifyListeners();
  });

  late final _vaultsUpdatesSubscription =
      _vaultInteractor.watch().listen((final event) {
    if (event.deleted) {
      _vaults.remove(event.key);
      _shards.remove(event.key);
    } else {
      final vault = event.value as VaultModel;
      vault.ownerId == _settingsInteractor.selfId
          ? _vaults.add(vault.id)
          : _shards.add(vault.id);
    }
    notifyListeners();
  });
}
