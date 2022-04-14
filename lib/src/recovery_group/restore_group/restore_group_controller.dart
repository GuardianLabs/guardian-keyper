import 'package:flutter/material.dart';

import '../../core/model/p2p_model.dart';
import '../../core/controller/page_controller.dart';

class RestoreGroupController with ChangeNotifier, PagesController {
  final Stream<P2PPacket> p2pNetwork;
  String? _groupName;
  String? error;
  String? stackTrace;

  RestoreGroupController({
    required int pagesCount,
    required this.p2pNetwork,
  }) {
    this.pagesCount = pagesCount;
    p2pNetwork.listen(
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
