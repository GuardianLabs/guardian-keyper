import 'package:flutter/material.dart';

import '../recovery_group_model.dart';
import '../../core/page_controller.dart';

class CreateGroupController with ChangeNotifier, PagesController {
  CreateGroupController({required int lastScreen}) {
    this.lastScreen = lastScreen;
  }

  final _group = RecoveryGroupModel(name: 'New group');
  String? _errName;

  RecoveryGroupModel get group => _group;
  String? get errName => _errName;

  set groupType(RecoveryGroupType value) {
    _group.type = value;
    notifyListeners();
  }

  set groupName(String value) {
    if (_errName != null) _errName = null;
    _group.name = value;
    notifyListeners();
  }

  set errName(String? value) {
    _errName = value;
    notifyListeners();
  }
}
