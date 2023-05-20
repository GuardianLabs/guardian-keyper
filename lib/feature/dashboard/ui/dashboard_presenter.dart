import 'package:get_it/get_it.dart';
import 'package:flutter/foundation.dart';

import 'package:guardian_keyper/data/services/platform_service.dart';
import 'package:guardian_keyper/data/services/preferences_service.dart';
import 'package:guardian_keyper/domain/entity/peer_id.dart';
import 'package:guardian_keyper/feature/vault/domain/entity/vault_id.dart';
import 'package:guardian_keyper/feature/vault/domain/use_case/vault_interactor.dart';
import 'package:guardian_keyper/feature/message/domain/use_case/message_interactor.dart';
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
    _settingsChanges.resume();
    _vaultChanges.resume();
  }

  @override
  void dispose() {
    _settingsChanges.cancel();
    _vaultChanges.cancel();
    super.dispose();
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

  late final _settingsChanges = _settingsInteractor.watch.listen((event) {
    if (event.key == keyDeviceName) notifyListeners();
  });

  late final _vaultChanges = _vaultInteractor.watch().listen((event) {
    if (event.isDeleted) {
      _vaults.remove(event.key);
      _shards.remove(event.key);
    } else {
      event.vault!.ownerId == _settingsInteractor.selfId
          ? _vaults.add(event.vault!.id)
          : _shards.add(event.vault!.id);
    }
    notifyListeners();
  });
}
