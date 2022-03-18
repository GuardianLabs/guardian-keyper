import 'dart:convert';
import 'package:flutter/material.dart';

import '../../core/controller/page_controller.dart';
import '../../core/model/p2p_model.dart';

class AddGuardianController with ChangeNotifier, PagesController {
  AddGuardianController({
    required int pagesCount,
    required this.groupName,
    required this.p2pNetwork,
    this.showLastPage = false,
  }) {
    this.pagesCount = pagesCount;
    p2pNetwork.listen(
      (p2pPacket) {
        if (p2pPacket.type == MessageType.authPeer &&
            p2pPacket.status == MessageStatus.success &&
            _guardianName.isEmpty) {
          _guardianName = p2pPacket.body.isEmpty
              ? 'No name'
              : String.fromCharCodes(p2pPacket.body);
          notifyListeners();
        }
      },
      onError: (Object? e, StackTrace s) {
        error = e.toString();
        stackTrace = s.toString();
        notifyListeners();
      },
    );
  }

  final Stream<P2PPacket> p2pNetwork;
  final String groupName;
  final bool showLastPage;
  String _guardianName = '';
  String _guardianCode = '';
  String _tag = '';
  String? error;
  String? stackTrace;

  String get guardianTag => _tag;
  String get guardianName => _guardianName;
  String get guardianCode => _guardianCode;
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
}
