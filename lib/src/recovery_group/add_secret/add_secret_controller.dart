import 'package:sss256/sss256.dart';

import '/src/core/model/core_model.dart';
import '/src/core/service/analytics_service.dart';

import '../recovery_group_controller.dart';

export 'package:provider/provider.dart';

class AddSecretController extends RecoveryGroupSecretController {
  var secretName = '';
  var secret = '';

  AddSecretController({
    required super.diContainer,
    required super.pagesCount,
    required super.groupId,
  }) : super(secretId: SecretId(name: ''));

  void startRequest({
    required Callback onSuccess,
    required Callback onReject,
    required Callback onFailed,
  }) {
    diContainer.analyticsService.logEvent(eventStartAddSecret);
    networkSubscription = networkStream.listen(
      (message) {
        if (message.code != MessageCode.setShard) return;
        if (!message.hasResponse) return;
        if (!messages.contains(message)) return;
        updateMessage(message);
        if (message.isAccepted) {
          if (messagesWithSuccess.length == group.maxSize) {
            diContainer.analyticsService.logEvent(eventFinishAddSecret);
            diContainer.boxRecoveryGroups
                .put(
                  group.aKey,
                  group.copyWith(secrets: {...group.secrets, secretId: ''}),
                )
                .then((_) => onSuccess(message));
          }
        } else {
          stopListenResponse();
          message.isRejected ? onReject(message) : onFailed(message);
        }
      },
    );
    _splitSecret();
    startNetworkRequest(requestShards);
  }

  /// fill messages with request
  void _splitSecret() {
    final shards = splitSecret(
      treshold: group.threshold,
      shares: group.maxSize,
      secret: secret,
    );
    if (secret != restoreSecret(shares: shards.sublist(0, group.threshold))) {
      throw const FormatException('Can not restore the secret!');
    }
    secretId = secretId.copyWith(name: secretName);
    final shardsIterator = shards.iterator;
    for (final guardian in group.guardians.keys) {
      if (shardsIterator.moveNext()) {
        messages.add(MessageModel(
          peerId: guardian,
          code: MessageCode.setShard,
          payload: SecretShardModel(
            id: secretId,
            ownerId: diContainer.myPeerId,
            groupId: group.id,
            groupSize: group.size,
            groupThreshold: group.threshold,
            shard: shardsIterator.current,
          ),
        ));
      }
    }
  }
}
