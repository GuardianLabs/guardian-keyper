import 'package:sss256/sss256.dart';

import 'package:guardian_keyper/src/core/consts.dart';
import 'package:guardian_keyper/src/message/domain/message_model.dart';

import '../vault_presenter_base.dart';
import '../../domain/secret_shard_model.dart';

export 'package:provider/provider.dart';

class VaultAddSecretPresenter extends VaultSecretPresenterBase {
  var _secretName = '';
  var _secret = '';

  String get secret => _secret;

  bool get isNameTooShort => _secretName.length < minNameLength;

  set secret(String value) {
    _secret = value;
    notifyListeners();
  }

  set secretName(String value) {
    _secretName = value;
    notifyListeners();
  }

  VaultAddSecretPresenter({required super.pages, required super.vaultId})
      : super(secretId: SecretId.aNew());

  void startRequest({
    required Callback onSuccess,
    required Callback onReject,
    required Callback onFailed,
  }) {
    logStartAddSecret();
    networkSubscription.onData(
      (final incomeMessage) async {
        if (incomeMessage.code != MessageCode.setShard) return;
        final message = checkAndUpdateMessage(incomeMessage);
        if (message == null) return;
        if (message.isAccepted) {
          if (messages.where((m) => m.isAccepted).length == vault.maxSize) {
            stopListenResponse();
            await addSecret(
              vault: vault,
              secretId: secretId,
              secretValue: vault.isSelfGuarded
                  ? messages
                      .firstWhere((m) => m.ownerId == myPeerId)
                      .secretShard
                      .shard
                  : '',
            );
            logFinishAddSecret();
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
      treshold: vault.threshold,
      shares: vault.maxSize,
      secret: _secret,
    );
    if (_secret != restoreSecret(shares: shards.sublist(0, vault.threshold))) {
      throw const FormatException('Can not restore the secret!');
    }
    secretId = secretId.copyWith(name: _secretName);
    final shardsIterator = shards.iterator;
    for (final guardian in vault.guardians.keys) {
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
            vaultId: vault.id,
            groupSize: vault.size,
            groupThreshold: vault.threshold,
            shard: shardsIterator.current,
          ),
        ));
      }
    }
  }
}
