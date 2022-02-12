import 'package:flutter/material.dart';

import '../../core/controller/page_controller.dart';

class AddGuardianController with ChangeNotifier, PagesController {
  AddGuardianController({
    required int lastPage,
    required this.groupName,
    this.showLastPage = false,
  }) {
    this.lastPage = lastPage;
  }

  final String groupName;
  final bool showLastPage;
  String guardianName = '';
  String guardianCode = '';
  String _tag = '';

  String get guardianTag => _tag;
  String get guardianCodeHex =>
      '0x' +
      guardianCode.substring(0, 10) +
      '...' +
      guardianCode.substring(guardianCode.length - 10);

  set guardianTag(String value) {
    _tag = value;
    notifyListeners();
  }
}
