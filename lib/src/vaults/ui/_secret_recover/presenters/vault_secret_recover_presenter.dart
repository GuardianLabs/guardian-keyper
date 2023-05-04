import 'package:get_it/get_it.dart';
import 'package:sss256/sss256.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';

import 'package:guardian_keyper/src/core/ui/widgets/auth/auth.dart';
import 'package:guardian_keyper/src/message/domain/message_model.dart';

import '../../../domain/secret_shard_model.dart';
import '../../../domain/vault_interactor.dart';
import '../../presenters/vault_secret_presenter_base.dart';

export 'package:provider/provider.dart';

class VaultSecretRecoverPresenter extends VaultSecretPresenterBase {
  VaultSecretRecoverPresenter({
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
          ownerId: _vaultInteractor.selfId,
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

  String get secret => _secret;
  bool get isObfuscated => _isObfuscated;
  bool get isAuthorized => _isAuthorized;

  Future<void> checkPassCode({
    required final BuildContext context,
    required final void Function() onUnlocked,
  }) =>
      showAskPassCode(
        context: context,
        onUnlocked: onUnlocked,
        onVibrate: _vaultInteractor.vibrate,
        currentPassCode: _vaultInteractor.passCode,
        useBiometrics: _vaultInteractor.useBiometrics,
        localAuthenticate: _vaultInteractor.localAuthenticate,
      );

  Future<MessageModel> startRequest() async {
    networkSubscription.resume();
    await startNetworkRequest();
    return requestCompleter.future;
  }

  void _onMessage(final MessageModel incomeMessage) async {
    if (incomeMessage.code != MessageCode.getShard) return;
    final message = checkAndUpdateMessage(incomeMessage);
    if (message == null) return;
    if (messages.where((m) => m.isAccepted).length >= vault.threshold) {
      stopListenResponse();
      _vaultInteractor.logFinishRestoreSecret();
      _secret = await compute<List<String>, String>(
        (List<String> shares) => restoreSecret(shares: shares),
        messages
            .where((e) => e.secretShard.shard.isNotEmpty)
            .map((e) => e.secretShard.shard)
            .toList(),
      );
      requestCompleter.complete(message);
      nextPage();
    } else if (messages.where((e) => e.isRejected).length > vault.redudancy) {
      stopListenResponse();
      requestCompleter.complete(message.copyWith(
        status: MessageStatus.rejected,
      ));
    } else {
      notifyListeners();
    }
  }

  final _vaultInteractor = GetIt.I<VaultInteractor>();

  String _secret = '';
  bool _isObfuscated = true;
  bool _isAuthorized = false;
}
