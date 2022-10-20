import 'package:guardian_keyper/src/core/model/core_model.dart';

import '/src/core/service/analytics_service.dart';

import '../recovery_group_controller.dart';

export 'package:provider/provider.dart';

class CreateGroupController extends RecoveryGroupController {
  int _groupSize = 3;
  int _groupThreshold = 2;
  String _groupName = '';

  CreateGroupController({
    required super.diContainer,
    required super.pagesCount,
  }) {
    diContainer.analyticsService.logEvent(eventStartCreateVault);
  }

  int get groupSize => _groupSize;
  int get groupThreshold => _groupThreshold;
  String get groupName => _groupName;

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
