import 'package:get_it/get_it.dart';
import 'package:flutter/foundation.dart';

import 'package:guardian_keyper/domain/entity/_id/vault_id.dart';
import 'package:guardian_keyper/domain/entity/vault_model.dart';

import '../../domain/vault_interactor.dart';

export 'package:provider/provider.dart';

class ShardHomePresenter extends ChangeNotifier {
  ShardHomePresenter() {
    // cache shards
    for (final vault in _vaultInteractor.vaults) {
      if (vault.ownerId != _vaultInteractor.selfId) _shards[vault.id] = vault;
    }
    // init subscription
    _vaultsUpdatesSubscription.resume();
  }

  Map<VaultId, VaultModel> get shards => _shards;

  @override
  void dispose() {
    _vaultsUpdatesSubscription.cancel();
    super.dispose();
  }

  final _shards = <VaultId, VaultModel>{};
  final _vaultInteractor = GetIt.I<VaultInteractor>();

  late final _vaultsUpdatesSubscription =
      _vaultInteractor.watch().listen((final event) {
    if (event.isDeleted) {
      _shards.removeWhere((_, v) => v.aKey == event.key);
    } else {
      final vault = event.value as VaultModel;
      if (vault.ownerId != _vaultInteractor.selfId) _shards[vault.id] = vault;
    }
    notifyListeners();
  });
}