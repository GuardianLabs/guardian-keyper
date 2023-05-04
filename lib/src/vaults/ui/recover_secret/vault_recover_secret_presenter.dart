import 'package:get_it/get_it.dart';
import 'package:sss256/sss256.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';

import 'package:guardian_keyper/src/core/ui/widgets/auth/auth.dart';
import 'package:guardian_keyper/src/message/domain/message_model.dart';

import '../../domain/secret_shard_model.dart';
import '../../domain/vault_interactor.dart';
import '../presenters/vault_secret_presenter_base.dart';

export 'package:provider/provider.dart';

class VaultRecoverySecretPresenter extends VaultSecretPresenterBase {
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
          ownerId: selfId,
          vaultId: vaultId,
          groupSize: vault.maxSize,
          groupThreshold: vault.threshold,
          shard: guardian == vault.ownerId ? vault.secrets[secretId]! : '',
        ),
      ));
    }
    _vaultInteractor.logStartRestoreSecret();
  }

  @override
  late final networkSubscription =
      _vaultInteractor.messageStream.listen(_onMessage);

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
    _onRejected = onRejected;
    networkSubscription.resume();
    startNetworkRequest();
  }

  void _onMessage(final MessageModel incomeMessage) async {
    if (incomeMessage.code != MessageCode.getShard) return;
    final message = checkAndUpdateMessage(incomeMessage);
    if (message == null) return;
    if (messages.where((m) => m.isAccepted).length >= vault.threshold) {
      stopListenResponse();
      _vaultInteractor.logFinishRestoreSecret();
      secret = await compute<List<String>, String>(
        (List<String> shares) => restoreSecret(shares: shares),
        messages
            .where((e) => e.secretShard.shard.isNotEmpty)
            .map((e) => e.secretShard.shard)
            .toList(),
      );
      nextPage();
    } else if (messages.where((e) => e.isRejected).length > vault.redudancy) {
      stopListenResponse();
      _onRejected(message);
    } else {
      notifyListeners();
    }
  }

  late final Callback _onRejected;

  final _vaultInteractor = GetIt.I<VaultInteractor>();

  String secret = '';
}
