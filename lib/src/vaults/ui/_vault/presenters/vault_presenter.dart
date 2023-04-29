import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

import '../../../domain/vault_model.dart';
import '../../../domain/vault_interactor.dart';

export 'package:provider/provider.dart';

class VaultPresenter extends ChangeNotifier {
  VaultPresenter({required VaultId vaultId}) {
    _vault = _vaultInteractor.getVaultById(vaultId)!;
    _vaultChangesSubscription.resume();
  }

  late final pingPeer = _vaultInteractor.pingPeer;

  VaultModel get vault => _vault;

  @override
  void dispose() {
    _vaultChangesSubscription.cancel();
    super.dispose();
  }

  final _vaultInteractor = GetIt.I<VaultInteractor>();

  late final _vaultChangesSubscription =
      _vaultInteractor.watch(key: _vault.aKey).listen((final event) {
    if (event.deleted) return;
    _vault = event.value as VaultModel;
    notifyListeners();
  });

  late VaultModel _vault;
}
