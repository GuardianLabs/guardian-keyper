import 'package:flutter/widgets.dart';

import 'recovery_group_model.dart';
import 'recovery_group_service.dart';

class RecoveryGroupController with ChangeNotifier {
  RecoveryGroupController(this._recoveryGroupService);

  final RecoveryGroupService _recoveryGroupService;

  Map<String, RecoveryGroupModel> _groups = {};

  Map<String, RecoveryGroupModel> get groups => _groups;

  Future<void> load() async {
    _groups = await _recoveryGroupService.getGroups();
  }

  Future<void> addGroup(RecoveryGroupModel group) async {
    if (_groups.containsKey(group.name)) {
      throw RecoveryGroupAlreadyExists();
    }
    _groups[group.name] = group;
    notifyListeners();
  }

  Future<void> addGuardian(
    String groupName,
    RecoveryGroupGuardianModel guardian,
  ) async {
    if (!_groups.containsKey(groupName)) {
      throw RecoveryGroupDoesNotExist();
    }
    final group = _groups[groupName]!;
    if (group.guardians.containsKey([guardian.name])) {
      throw RecoveryGroupGuardianAlreadyExists();
    }
    group.guardians[guardian.name] = guardian;
    _groups[groupName] = group;
    notifyListeners();
  }
}

class RecoveryGroupAlreadyExists implements Exception {
  static const description = 'Group with given name already exists!';
}

class RecoveryGroupDoesNotExist implements Exception {
  static const description = 'Group with given name does not exist!';
}

class RecoveryGroupGuardianAlreadyExists implements Exception {
  static const description =
      'Guardian with given name already exists in that group!';
}
