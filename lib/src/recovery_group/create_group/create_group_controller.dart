import 'package:guardian_keyper/src/core/model/core_model.dart';

import '/src/core/service/analytics_service.dart';

import '../recovery_group_controller.dart';

export 'package:provider/provider.dart';

class CreateGroupController extends RecoveryGroupController {
  var _groupSize = 3;
  var _groupThreshold = 2;
  var _groupName = '';

  CreateGroupController({
    required super.diContainer,
    required super.pages,
  }) {
    diContainer.analyticsService.logEvent(eventStartCreateVault);
  }

  int get groupSize => _groupSize;
  int get groupThreshold => _groupThreshold;
  bool get isGroupNameToolShort => _groupName.length < globals.minNameLength;

  set groupSize(int size) {
    _groupSize = size;
    notifyListeners();
  }

  set groupThreshold(int size) {
    _groupThreshold = size;
    notifyListeners();
  }

  set groupName(String value) {
    _groupName = value;
    notifyListeners();
  }

  Future<RecoveryGroupModel> createVault() {
    diContainer.analyticsService.logEvent(eventFinishCreateVault);
    return createGroup(RecoveryGroupModel(
      id: GroupId(name: _groupName),
      maxSize: _groupSize,
      threshold: _groupThreshold,
      ownerId: diContainer.myPeerId,
    ));
  }
}
