import 'package:flutter/material.dart';
import 'package:p2plib/p2plib.dart';

import '../../core/controller/page_controller.dart';
import '../../core/model/p2p_model.dart';

class RecoverySecretController with ChangeNotifier, PagesController {
  RecoverySecretController({
    required int pagesCount,
    required this.groupName,
    required this.p2pNetwork,
  }) {
    this.pagesCount = pagesCount;
    p2pNetwork.listen(
      (p2pPacket) {
        if (p2pPacket.status == MessageStatus.success &&
            p2pPacket.type == MessageType.getShard) {
          _shards[p2pPacket.peerPubKey!] = String.fromCharCodes(p2pPacket.body);
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

  final String groupName;
  final Stream<P2PPacket> p2pNetwork;
  final Map<PubKey, String> _shards = {};
  String? error;
  String? stackTrace;

  Map<PubKey, String> get shards => _shards;
}
