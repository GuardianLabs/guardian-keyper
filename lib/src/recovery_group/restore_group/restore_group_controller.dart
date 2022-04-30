import 'package:flutter/material.dart';

import '/src/core/model/p2p_model.dart';
import '/src/core/controller/page_controller.dart';

import '../recovery_group_controller.dart';

class RestoreGroupController with ChangeNotifier, PagesController {
  final RecoveryGroupController recoveryGroupController;
  String? _groupName;
  String? error;
  String? stackTrace;

  RestoreGroupController({
    required int pagesCount,
    required this.recoveryGroupController,
  }) {
    this.pagesCount = pagesCount;
    recoveryGroupController.p2pNetwork.stream.listen(
      (p2pPacket) {
        if (p2pPacket.type != MessageType.takeOwnership) return;
        if (_groupName == null && p2pPacket.status == MessageStatus.request) {
          _groupName = SecretShardPacket.fromCbor(p2pPacket.body).groupName;
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

  String? get groupName => _groupName;
}
