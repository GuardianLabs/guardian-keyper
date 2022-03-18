import 'dart:typed_data';
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
          _peers.add(p2pPacket.peerPubKey!);
          secret = String.fromCharCodes(p2pPacket.body);
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
  final Map<String, Uint8List> _shards = {};
  final Stream<P2PPacket> p2pNetwork;
  final Set<PubKey> _peers = {};
  String secret = '';
  String? error;
  String? stackTrace;

  Map<String, Uint8List> get shards => _shards;
  Set<PubKey> get peers => _peers;

  void addShard(String guardianName, Uint8List shard) {
    _shards[guardianName] = shard;
    notifyListeners();
  }
}
