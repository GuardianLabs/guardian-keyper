import 'package:flutter/foundation.dart';
import 'package:sss256/sss256.dart';

import '/src/core/model/core_model.dart';
import '/src/core/service/analytics_service.dart';

import '../recovery_group_controller.dart';

class RecoverySecretController extends RecoveryGroupSecretController {
  String secret = '';

  RecoverySecretController({
    required super.diContainer,
    required super.pages,
    required super.groupId,
    required super.secretId,
  }) {
    // fill messages with request
    for (final guardian in group.guardians.keys) {
      messages.add(MessageModel(
        peerId: guardian,
        code: MessageCode.getShard,
        status: guardian == group.ownerId
            ? MessageStatus.accepted
            : MessageStatus.requested,
        payload: SecretShardModel(
          id: secretId,
          ownerId: diContainer.myPeerId,
          groupId: groupId,
          groupSize: group.maxSize,
          groupThreshold: group.threshold,
          shard: guardian == group.ownerId ? group.secrets[secretId]! : '',
        ),
      ));
    }
  }

  void startRequest({required Callback onRejected}) {
    diContainer.analyticsService.logEvent(eventStartRestoreSecret);
    networkSubscription.onData(
      (message) async {
        if (message.code != MessageCode.getShard) return;
        if (!message.hasResponse) return;
        if (!messages.contains(message)) return;
        updateMessage(message);
        if (messagesWithResponse.length >= group.threshold) {
          stopListenResponse();
          await diContainer.analyticsService.logEvent(eventFinishRestoreSecret);
          secret = await compute<List<String>, String>(
            (List<String> shares) => restoreSecret(shares: shares),
            messages
                .where((e) => e.secretShard.shard.isNotEmpty)
                .map((e) => e.secretShard.shard)
                .toList(),
          );
          nextScreen();
        } else if (messagesNotSuccess.length > group.redudancy) {
          onRejected(message);
        }
      },
    );
    startNetworkRequest(requestShards);
  }
}
