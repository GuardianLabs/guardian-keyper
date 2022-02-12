import 'package:flutter/material.dart';

import '../recovery_group_model.dart';
import '../../core/page_controller.dart';

class CreateGroupController with ChangeNotifier, PagesController {
  CreateGroupController({required int lastPage}) {
    this.lastPage = lastPage;
  }

  RecoveryGroupType? _groupType;
  String _groupName = '';
  String? _groupNameError;

  RecoveryGroupType? get groupType => _groupType;
  String get groupName => _groupName;
  String? get groupNameError => _groupNameError;

  set groupType(RecoveryGroupType? value) {
    _groupType = value;
    notifyListeners();
  }

  set groupName(String value) {
    _groupName = value;
    notifyListeners();
  }

  set groupNameError(String? value) {
    _groupNameError = value;
    notifyListeners();
  }
}
