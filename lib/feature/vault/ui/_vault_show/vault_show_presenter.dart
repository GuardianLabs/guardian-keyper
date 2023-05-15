import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

import 'package:guardian_keyper/feature/vault/domain/entity/vault_id.dart';
import 'package:guardian_keyper/feature/vault/domain/entity/vault.dart';

import '../../domain/vault_interactor.dart';

export 'package:provider/provider.dart';

class VaultShowPresenter extends ChangeNotifier {
  VaultShowPresenter({required VaultId vaultId}) {
    _vault = _vaultInteractor.getVaultById(vaultId)!;
    _vaultChanges.resume();
  }

  late final pingPeer = _vaultInteractor.pingPeer;

  Vault get vault => _vault;

  @override
  void dispose() {
    _vaultChanges.cancel();
    super.dispose();
  }

  final _vaultInteractor = GetIt.I<VaultInteractor>();

  late final _vaultChanges =
      _vaultInteractor.watch(_vault.aKey).listen((event) {
    if (event.isDeleted) return;
    _vault = event.vault!;
    notifyListeners();
  });

  late Vault _vault;
}
