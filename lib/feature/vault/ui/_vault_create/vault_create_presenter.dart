import 'package:guardian_keyper/consts.dart';
import 'package:guardian_keyper/ui/presenters/page_presenter_base.dart';
import 'package:guardian_keyper/feature/vault/domain/entity/vault.dart';
import 'package:guardian_keyper/feature/vault/domain/entity/vault_id.dart';
import 'package:guardian_keyper/feature/vault/domain/use_case/vault_interactor.dart';

export 'package:provider/provider.dart';

class VaultCreatePresenter extends PagePresenterBase {
  VaultCreatePresenter({required super.pageCount}) {
    _vaultInteractor.logStartCreateVault();
  }

  final _vaultInteractor = GetIt.I<VaultInteractor>();

  late final Vault vault;

  var _vaultSize = 3;
  var _vaultThreshold = 2;
  var _isVaultMember = false;
  var _vaultName = '';

  int get vaultSize => _vaultSize;

  bool get isVaultMember => _isVaultMember;

  bool get isVaultNameTooShort => _vaultName.length < minNameLength;

  void setVaultSize(int size, int vaultThreshold) {
    _vaultSize = size;
    _vaultThreshold = vaultThreshold;
    notifyListeners();
  }

  void setVaultName(String value) {
    _vaultName = value;
    notifyListeners();
  }

  void toggleVaultMembership() {
    _isVaultMember = !_isVaultMember;
    notifyListeners();
  }

  Future<void> createVault() async {
    vault = await _vaultInteractor.createVault(Vault(
      id: VaultId(name: _vaultName),
      maxSize: _vaultSize,
      threshold: _vaultThreshold,
      ownerId: _vaultInteractor.selfId,
      guardians: {if (_isVaultMember) _vaultInteractor.selfId: ''},
    ));
    _vaultInteractor.logFinishCreateVault();
    nextPage();
  }
}
