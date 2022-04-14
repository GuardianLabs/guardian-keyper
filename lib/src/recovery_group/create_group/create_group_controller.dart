import 'package:flutter/material.dart';

import '../../core/model/p2p_model.dart' show RecoveryGroupType;
import '../../core/controller/page_controller.dart';

class CreateGroupController with ChangeNotifier, PagesController {
  CreateGroupController({required int pagesCount}) {
    this.pagesCount = pagesCount;
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
