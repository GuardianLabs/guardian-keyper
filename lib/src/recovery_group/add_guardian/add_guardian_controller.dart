import 'package:flutter/material.dart';

import '../../core/controller/page_controller.dart';

class AddGuardianController with ChangeNotifier, PagesController {
  AddGuardianController({
    required int pagesCount,
    required this.groupName,
    this.showLastPage = false,
  }) {
    this.pagesCount = pagesCount;
  }

  final String groupName;
  final bool showLastPage;
  String guardianName = '';
  String guardianCode = '';
  String _tag = '';

  String get guardianTag => _tag;
  String get guardianCodeHex =>
      '${guardianCode.substring(0, 10)}...${guardianCode.substring(guardianCode.length - 10)}';

  set guardianTag(String value) {
    _tag = value;
    notifyListeners();
  }
}
