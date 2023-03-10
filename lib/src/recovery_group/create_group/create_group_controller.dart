import '/src/core/model/core_model.dart';
import '/src/settings/settings_model.dart';
import '/src/core/service/analytics_service.dart';

import '../recovery_group_controller.dart';

export 'package:provider/provider.dart';

class CreateGroupController extends RecoveryGroupControllerBase {
  var _groupSize = 3;
  var _groupThreshold = 2;
  var _isGroupMember = false;
  var _groupName = '';

  CreateGroupController({
    required super.diContainer,
    required super.pages,
  }) {
    GetIt.I<AnalyticsService>().logEvent(eventStartCreateVault);
  }

  int get groupSize => _groupSize;

  int get groupThreshold => _groupThreshold;

  bool get isGroupMember => _isGroupMember;

  bool get isGroupNameToolShort =>
      _groupName.length < SettingsModel.minNameLength;

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

  Future<RecoveryGroupModel> createVault() {
    GetIt.I<AnalyticsService>().logEvent(eventFinishCreateVault);
    return createGroup(RecoveryGroupModel(
      id: GroupId(name: _groupName),
      maxSize: _groupSize,
      threshold: _groupThreshold,
      ownerId: diContainer.myPeerId,
      guardians: {
        if (_isGroupMember) diContainer.myPeerId: '',
      },
    ));
  }
}
