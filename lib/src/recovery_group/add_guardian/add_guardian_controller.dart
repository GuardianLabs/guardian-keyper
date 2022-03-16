import 'dart:convert';

import 'package:flutter/material.dart';

import '../../core/controller/page_controller.dart';
import '../../core/model/p2p_model.dart';

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
  String _guardianName = '';
  String _guardianCode = '';
  String _tag = '';

  String get guardianTag => _tag;
  String get guardianName => _guardianName;
  String get guardianCode => _guardianCode;
  String get guardianPubKey =>
      base64Encode(QRCode.fromBase64(guardianCode).pubKey);
  //'${guardianCode.substring(0, 10)}...${guardianCode.substring(guardianCode.length - 10)}';

  set guardianTag(String value) {
    _tag = value;
    notifyListeners();
  }

  set guardianName(String value) {
    _guardianName = value;
    notifyListeners();
  }

  set guardianCode(String value) {
    _guardianCode = value;
    notifyListeners();
  }
}
