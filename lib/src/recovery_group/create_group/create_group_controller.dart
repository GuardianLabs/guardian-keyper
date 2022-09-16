import '/src/core/model/core_model.dart';

import '../recovery_group_controller.dart';

export 'package:provider/provider.dart';

class CreateGroupController extends RecoveryGroupController {
  RecoveryGroupType? _groupType;
  int _groupSize = 3;
  String _groupName = '';

  CreateGroupController({
    required super.diContainer,
    required super.pagesCount,
  });

  RecoveryGroupType? get groupType => _groupType;
  int get groupSize => _groupSize;
  String get groupName => _groupName;

  set groupType(RecoveryGroupType? value) {
    _groupType = value;
    notifyListeners();
  }

  set groupSize(int size) {
    _groupSize = size;
    notifyListeners();
  }

  set groupName(String value) {
    _groupName = value;
    notifyListeners();
  }
}
