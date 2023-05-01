import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:sss256/sss256.dart';

import '../../../core/domain/entity/core_model.dart';
import '/src/core/ui/widgets/auth/auth.dart';

import '../presenters/vault_presenter_base.dart';

export 'package:provider/provider.dart';

class VaultRecoverySecretPresenter extends VaultSecretPresenterBase {
  String secret = '';

  VaultRecoverySecretPresenter({
    required super.pages,
    required super.vaultId,
    required super.secretId,
  }) {
    // fill messages with request
    for (final guardian in vault.guardians.keys) {
      messages.add(MessageModel(
        peerId: guardian,
        code: MessageCode.getShard,
        status: guardian == vault.ownerId
            ? MessageStatus.accepted
            : MessageStatus.created,
        payload: SecretShardModel(
          id: secretId,
          ownerId: myPeerId,
          vaultId: vaultId,
          groupSize: vault.maxSize,
          groupThreshold: vault.threshold,
          shard: guardian == vault.ownerId ? vault.secrets[secretId]! : '',
        ),
      ));
    }
  }

  Future<void> checkPassCode({
    required final BuildContext context,
    required final void Function() onUnlocked,
  }) =>
      showAskPassCode(
        context: context,
        onUnlocked: onUnlocked,
        onVibrate: vibrate,
        currentPassCode: passCode,
        localAuthenticate: localAuthenticate,
        useBiometrics: useBiometrics,
      );

  void startRequest({required Callback onRejected}) {
    logStartRestoreSecret();
    networkSubscription.onData(
      (final incomeMessage) async {
        if (incomeMessage.code != MessageCode.getShard) return;
        final message = checkAndUpdateMessage(incomeMessage);
        if (message == null) return;
        if (messages.where((m) => m.isAccepted).length >= vault.threshold) {
          stopListenResponse();
          logFinishRestoreSecret();
          secret = await compute<List<String>, String>(
            (List<String> shares) => restoreSecret(shares: shares),
            messages
                .where((e) => e.secretShard.shard.isNotEmpty)
                .map((e) => e.secretShard.shard)
                .toList(),
          );
          nextPage();
        } else if (messages.where((e) => e.isRejected).length >
            vault.redudancy) {
          stopListenResponse();
          onRejected(message);
        } else {
          notifyListeners();
        }
      },
    );
    startNetworkRequest(requestShards);
  }
}
