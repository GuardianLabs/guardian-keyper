import 'dart:async';
import 'package:flutter/material.dart';
import 'package:p2plib/p2plib.dart';

import '/src/core/controller/page_controller.dart';
import '/src/core/model/p2p_model.dart';

import '../recovery_group_model.dart';
import '../recovery_group_controller.dart';

class RecoverySecretController with ChangeNotifier, PagesController {
  final RecoveryGroupController recoveryGroupController;
  final String groupName;
  final Map<PubKey, String> _shards = {};
  late final RecoveryGroupModel group;
  Timer? timer;
  String? error;
  String? stackTrace;

  RecoverySecretController({
    required int pagesCount,
    required this.groupName,
    required this.recoveryGroupController,
  }) {
    this.pagesCount = pagesCount;
    group = recoveryGroupController.groups[groupName]!;
    recoveryGroupController.p2pNetwork.stream.listen(
      (p2pPacket) {
        if (p2pPacket.status == MessageStatus.success &&
            p2pPacket.type == MessageType.getShard) {
          _shards[p2pPacket.peerPubKey!] = String.fromCharCodes(p2pPacket.body);
          if (_shards.length == group.threshold) timer?.cancel();
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

  Map<PubKey, String> get shards => _shards;

  String get secret =>
      recoveryGroupController.restoreSecret(shards.values.toList());

  void requestShards() async {
    try {
      await recoveryGroupController.requestShards(
          groupName, _shards.keys.toSet());
    } catch (_) {}

    timer = Timer.periodic(const Duration(seconds: 3), ((_) async {
      try {
        await recoveryGroupController.requestShards(
            groupName, _shards.keys.toSet());
      } catch (_) {}
    }));
  }
}
