import 'dart:async';
import 'package:flutter/material.dart';
import 'package:p2plib/p2plib.dart' show PubKey;

import '/src/core/controller/page_controller.dart';
import '/src/core/model/p2p_model.dart';

import '../recovery_group_model.dart';
import '../recovery_group_controller.dart';

class AddSecretController with ChangeNotifier, PagesController {
  final RecoveryGroupController recoveryGroupController;
  final String groupName;
  Map<PubKey, String> shards = {};
  String secret = '';
  Timer? timer;
  String? error;
  String? stackTrace;

  AddSecretController({
    required int pagesCount,
    required this.groupName,
    required this.recoveryGroupController,
  }) {
    this.pagesCount = pagesCount;
    recoveryGroupController.p2pNetwork.stream.listen(
      (p2pPacket) async {
        if (p2pPacket.status == MessageStatus.success &&
            p2pPacket.type == MessageType.setShard) {
          shards.remove(p2pPacket.peerPubKey);
          if (shards.isEmpty) {
            await recoveryGroupController.addSecret(
              groupName,
              RecoveryGroupSecretModel(name: groupName, token: secret),
            );
            timer?.cancel();
          }
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

  void distributeShards() async {
    try {
      await recoveryGroupController.distributeShards(shards, groupName, secret);
    } catch (_) {}

    timer = Timer.periodic(const Duration(seconds: 3), ((_) async {
      try {
        await recoveryGroupController.distributeShards(
            shards, groupName, secret);
      } catch (_) {}
    }));
  }
}
