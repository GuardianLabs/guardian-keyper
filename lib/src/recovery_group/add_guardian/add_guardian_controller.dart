import 'package:flutter/material.dart';

import '../recovery_group_model.dart';
import '../../core/page_controller.dart';

class AddGuardianController with ChangeNotifier, PagesController {
  AddGuardianController({required int lastScreen, required this.group}) {
    this.lastScreen = lastScreen;
  }

  final RecoveryGroupModel group;
  final _guardian = RecoveryGroupGuardianModel();

  RecoveryGroupGuardianModel get guardian => _guardian;

  set guardianName(String value) {
    _guardian.name = value;
    notifyListeners();
  }

  set code(String value) {
    _guardian.code = value;
  }

  set tag(String value) {
    _guardian.tag = value;
    notifyListeners();
  }
}
