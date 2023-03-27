import '/src/core/data/core_model.dart';
import '/src/core/service/analytics_service.dart';

import '../../vault_presenter.dart';

export 'package:provider/provider.dart';

class VaultCreateController extends VaultPresenterBase {
  var _groupSize = 3;
  var _groupThreshold = 2;
  var _isGroupMember = false;
  var _groupName = '';

  VaultCreateController({required super.pages}) {
    serviceRoot.analyticsService.logEvent(eventStartCreateVault);
  }

  int get groupSize => _groupSize;

  int get groupThreshold => _groupThreshold;

  bool get isGroupMember => _isGroupMember;

  bool get isGroupNameToolShort =>
      _groupName.length < IdWithNameBase.minNameLength;

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
    serviceRoot.analyticsService.logEvent(eventFinishCreateVault);
    return createGroup(VaultModel(
      id: VaultId(name: _groupName),
      maxSize: _groupSize,
      threshold: _groupThreshold,
      ownerId: myPeerId,
      guardians: {if (_isGroupMember) myPeerId: ''},
    ));
  }
}
