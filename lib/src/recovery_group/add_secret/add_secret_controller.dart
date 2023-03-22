import 'package:sss256/sss256.dart';

import '/src/core/model/core_model.dart';
import '/src/core/service/analytics_service.dart';

import '../recovery_group_controller.dart';

export 'package:provider/provider.dart';

class AddSecretController extends RecoveryGroupSecretController {
  var _secretName = '';
  var _secret = '';

  String get secret => _secret;

  bool get isNameTooShort => _secretName.length < IdWithNameBase.minNameLength;

  set secret(String value) {
    _secret = value;
    notifyListeners();
  }

  set secretName(String value) {
    _secretName = value;
    notifyListeners();
  }

  AddSecretController({required super.pages, required super.groupId})
      : super(secretId: SecretId(name: ''));

  void startRequest({
    required Callback onSuccess,
    required Callback onReject,
    required Callback onFailed,
  }) {
    serviceRoot.analyticsService.logEvent(eventStartAddSecret);
    networkSubscription.onData(
      (message) async {
        if (message.code != MessageCode.setShard) return;
        if (!message.hasResponse) return;
        if (!messages.contains(message)) return;
        updateMessage(message);
        if (message.isAccepted) {
          if (messages.where((m) => m.isAccepted).length == group.maxSize) {
            stopListenResponse();
            final shardValue = group.isSelfGuarded
                ? messages
                    .firstWhere((m) => m.ownerId == myPeerId)
                    .secretShard
                    .shard
                : '';
            await repositoryRoot.vaultRepository.put(
              group.aKey,
              group.copyWith(secrets: {...group.secrets, secretId: shardValue}),
            );
            await serviceRoot.analyticsService.logEvent(eventFinishAddSecret);
            onSuccess(message);
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
      secret: _secret,
    );
    if (_secret != restoreSecret(shares: shards.sublist(0, group.threshold))) {
      throw const FormatException('Can not restore the secret!');
    }
    secretId = secretId.copyWith(name: _secretName);
    final shardsIterator = shards.iterator;
    for (final guardian in group.guardians.keys) {
      if (shardsIterator.moveNext()) {
        messages.add(MessageModel(
          peerId: guardian,
          code: MessageCode.setShard,
          status: guardian == myPeerId
              ? MessageStatus.accepted
              : MessageStatus.created,
          payload: SecretShardModel(
            id: secretId,
            ownerId: myPeerId,
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
