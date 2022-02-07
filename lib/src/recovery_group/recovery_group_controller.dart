import 'package:flutter/widgets.dart';

import 'recovery_group_model.dart';
import 'recovery_group_service.dart';

class RecoveryGroupController with ChangeNotifier {
  RecoveryGroupController(this._recoveryGroupService);

  final RecoveryGroupService _recoveryGroupService;

  Map<String, RecoveryGroupModel> _groups = {};

  Map<String, RecoveryGroupModel> get groups => _groups;

  Future<void> addGroup(RecoveryGroupModel group) async {
    _groups[group.name] = group;
    notifyListeners();
  }

  Future<void> load() async {
    _groups = await _recoveryGroupService.getGroups();
  }
}
