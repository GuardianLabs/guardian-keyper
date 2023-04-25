import 'package:guardian_keyper/src/core/consts.dart';

import '../vault_presenter_base.dart';
import '../../domain/vault_model.dart';

export 'package:provider/provider.dart';

class VaultCreatePresenter extends VaultPresenterBase {
  var _groupSize = 3;
  var _groupThreshold = 2;
  var _isGroupMember = false;
  var _groupName = '';

  VaultCreatePresenter({required super.pages}) {
    logStartCreateVault();
  }

  int get groupSize => _groupSize;

  int get groupThreshold => _groupThreshold;

  bool get isGroupMember => _isGroupMember;

  bool get isGroupNameToolShort => _groupName.length < minNameLength;

  set groupSize(int size) {
    _groupSize = size;
    notifyListeners();
  }

  set groupThreshold(int size) {
    _groupThreshold = size;
    notifyListeners();
  }

  set isGroupMember(bool value) {
    _isGroupMember = value;
    notifyListeners();
  }

  set groupName(String value) {
    _groupName = value;
    notifyListeners();
  }

  Future<VaultModel> createVault() {
    logFinishCreateVault();
    return createGroup(VaultModel(
      id: VaultId.aNew(name: _groupName),
      maxSize: _groupSize,
      threshold: _groupThreshold,
      ownerId: myPeerId,
      guardians: {if (_isGroupMember) myPeerId: ''},
    ));
  }
}
