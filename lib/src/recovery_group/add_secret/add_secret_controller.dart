import 'package:flutter/material.dart';
import 'package:p2plib/p2plib.dart' show PubKey;

import '../../core/controller/page_controller.dart';
import '../../core/model/p2p_model.dart';

class AddSecretController with ChangeNotifier, PagesController {
  AddSecretController({
    required int pagesCount,
    required this.groupName,
    required this.p2pNetwork,
  }) {
    this.pagesCount = pagesCount;
    p2pNetwork.listen(
      (p2pPacket) {
        if (p2pPacket.status == MessageStatus.success &&
            p2pPacket.type == MessageType.setShard) {
          shards.remove(p2pPacket.peerPubKey!);
          notifyListeners();
        }
      },
      onError: (Object e, StackTrace s) {
        error = e.toString();
        stackTrace = s.toString();
        notifyListeners();
      },
    );
  }

  final String groupName;
  final Stream<P2PPacket> p2pNetwork;
  Map<PubKey, String> shards = {};
  String secret = '';
  String? error;
  String? stackTrace;
}
