import 'package:flutter/material.dart';

import '../../core/controller/page_controller.dart';
import '../recovery_group_model.dart';

class AddSecretController with ChangeNotifier, PagesController {
  AddSecretController({
    required int pagesCount,
    required this.groupName,
  }) {
    this.pagesCount = pagesCount;
  }

  final String groupName;
  String secret = '';
  final Map<String, RecoveryGroupGuardianModel> _guardians = {};

  Map<String, RecoveryGroupGuardianModel> get guardians => _guardians;

  void addGuardian(RecoveryGroupGuardianModel guardian) {
    _guardians[guardian.name] = guardian;
    notifyListeners();
  }
}
