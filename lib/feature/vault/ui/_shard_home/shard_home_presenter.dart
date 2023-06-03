import 'package:get_it/get_it.dart';
import 'package:flutter/foundation.dart';

import '../../domain/entity/vault.dart';
import '../../domain/entity/vault_id.dart';
import '../../domain/use_case/vault_interactor.dart';

export 'package:provider/provider.dart';

class ShardHomePresenter extends ChangeNotifier {
  ShardHomePresenter() {
    // cache shards
    for (final vault in _vaultInteractor.vaults) {
      if (vault.ownerId != _vaultInteractor.selfId) _shards[vault.id] = vault;
    }
    // init subscription
    _vaultChanges.resume();
  }

  Map<VaultId, Vault> get shards => _shards;

  @override
  void dispose() {
    _vaultChanges.cancel();
    super.dispose();
  }

  final _shards = <VaultId, Vault>{};
  final _vaultInteractor = GetIt.I<VaultInteractor>();

  late final _vaultChanges = _vaultInteractor.watch().listen((event) {
    if (event.isDeleted) {
      _shards.removeWhere((_, v) => v.aKey == event.key);
    } else if (event.vault!.ownerId != _vaultInteractor.selfId) {
      _shards[event.vault!.id] = event.vault!;
    }
    notifyListeners();
  });
}
