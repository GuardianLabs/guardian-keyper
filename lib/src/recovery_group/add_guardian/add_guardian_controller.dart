import 'package:flutter/material.dart';

import '../../core/page_controller.dart';

class AddGuardianController with ChangeNotifier, PagesController {
  AddGuardianController({required int lastScreen, required this.groupName}) {
    this.lastScreen = lastScreen;
  }

  final String groupName;
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
