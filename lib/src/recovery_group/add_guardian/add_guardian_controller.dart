import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';

import '/src/core/model/p2p_model.dart';
import '/src/core/controller/page_controller.dart';

import '../recovery_group_controller.dart';

class AddGuardianController with ChangeNotifier, PagesController {
  final RecoveryGroupController recoveryGroupController;
  final String groupName;
  final bool showLastPage;
  bool isDuplicate = false;
  String _guardianName = '';
  String _guardianCode = '';
  String _tag = '';
  Timer? timer;
  String? error;
  String? stackTrace;

  AddGuardianController({
    required int pagesCount,
    required this.groupName,
    required this.recoveryGroupController,
    this.showLastPage = false,
  }) {
    this.pagesCount = pagesCount;
    recoveryGroupController.p2pNetwork.stream.listen(
      (p2pPacket) {
        if (p2pPacket.type == MessageType.authPeer &&
            p2pPacket.status == MessageStatus.success &&
            _guardianName.isEmpty) {
          _guardianName = String.fromCharCodes(p2pPacket.body);
          final group = recoveryGroupController.groups[groupName]!;
          if (group.guardians.containsKey(_guardianName)) {
            isDuplicate = true;
            notifyListeners();
          } else {
            nextScreen();
          }
          timer?.cancel();
        }
      },
      onError: (Object? e, StackTrace s) {
        error = e.toString();
        stackTrace = s.toString();
        notifyListeners();
      },
    );
  }

  String get guardianTag => _tag;
  String get guardianName => _guardianName;
  String get guardianCode => _guardianCode;
  QRCode get guardianQRCode => QRCode.fromBase64(guardianCode);
  String get guardianPubKey =>
      base64Encode(QRCode.fromBase64(guardianCode).pubKey).substring(0, 16) +
      '...';

  set guardianTag(String value) {
    _tag = value;
    notifyListeners();
  }

  set guardianCode(String value) {
    _guardianCode = value;
    notifyListeners();
  }

  void sendAuthRequest() {
    try {
      recoveryGroupController.sendAuthRequest(guardianQRCode);
    } catch (_) {}
    timer = Timer.periodic(const Duration(seconds: 3), ((_) {
      try {
        recoveryGroupController.sendAuthRequest(guardianQRCode);
      } catch (_) {}
    }));
  }
}
