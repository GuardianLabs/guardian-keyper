import 'package:get_it/get_it.dart';

import 'package:guardian_keyper/consts.dart';
import 'package:guardian_keyper/ui/presenters/page_presenter_base.dart';

import '../../domain/entity/vault.dart';
import '../../domain/entity/vault_id.dart';
import '../../domain/use_case/vault_interactor.dart';

export 'package:provider/provider.dart';

class VaultCreatePresenter extends PagePresenterBase {
  VaultCreatePresenter({required super.pageCount}) {
    _vaultInteractor.logStartCreateVault();
  }

  late final chooseYourDevice = nextPage;

  int get vaultSize => _vaultSize;

  int get vaultThreshold => _vaultThreshold;

  int get atLeast => _isVaultMember ? _vaultSize - 1 : _vaultSize;

  int get ofAmount => _isVaultMember ? _vaultThreshold - 1 : _vaultThreshold;

  bool get isVaultMember => _isVaultMember;

  bool get isVaultNameTooShort => _vaultName.length < minNameLength;

  void setVaultSize(final int size, final int vaultThreshold) {
    _vaultSize = size;
    _vaultThreshold = vaultThreshold;
    notifyListeners();
  }

  void setVaultName(final String value) {
    _vaultName = value;
    notifyListeners();
  }

  void setVaultMembership(final bool value) {
    _isVaultMember = value;
    notifyListeners();
  }

  Future<Vault> createVault() async {
    final vault = await _vaultInteractor.createVault(Vault(
      id: VaultId(name: _vaultName),
      maxSize: _vaultSize,
      threshold: _vaultThreshold,
      ownerId: _vaultInteractor.selfId,
      guardians: {if (_isVaultMember) _vaultInteractor.selfId: ''},
    ));
    await _vaultInteractor.logFinishCreateVault();
    notifyListeners();
    return vault;
  }

  final _vaultInteractor = GetIt.I<VaultInteractor>();

  var _vaultSize = 3;
  var _vaultThreshold = 2;
  var _isVaultMember = false;
  var _vaultName = '';
}
