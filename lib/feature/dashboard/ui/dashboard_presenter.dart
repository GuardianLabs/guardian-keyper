import 'package:get_it/get_it.dart';
import 'package:flutter/foundation.dart';

import 'package:guardian_keyper/data/platform_service.dart';
import 'package:guardian_keyper/data/preferences_service.dart';
import 'package:guardian_keyper/domain/entity/_id/vault_id.dart';
import 'package:guardian_keyper/domain/entity/vault_model.dart';
import 'package:guardian_keyper/domain/entity/_id/peer_id.dart';
import 'package:guardian_keyper/feature/vault/domain/vault_interactor.dart';
import 'package:guardian_keyper/feature/message/domain/message_interactor.dart';
import 'package:guardian_keyper/feature/settings/domain/settings_interactor.dart';

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
    _settingsInteractor.settingsChanges.listen((final event) {
      if (event.key == keyDeviceName) notifyListeners();
    });
    _vaultInteractor.watch().listen((final event) {
      if (event.isDeleted) {
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

  late final share = _platformManager.share;
  late final createJoinVaultCode = _messagesInteractor.createJoinVaultCode;

  int get vaultsCount => _vaults.length;
  int get shardsCount => _shards.length;

  PeerId get selfId => _settingsInteractor.selfId;

  final _vaults = <VaultId>{};
  final _shards = <VaultId>{};

  final _platformManager = GetIt.I<PlatformService>();
  final _vaultInteractor = GetIt.I<VaultInteractor>();
  final _messagesInteractor = GetIt.I<MessageInteractor>();
  final _settingsInteractor = GetIt.I<SettingsInteractor>();
}