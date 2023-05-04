import 'package:get_it/get_it.dart';
import 'package:sss256/sss256.dart';

import 'package:guardian_keyper/src/core/consts.dart';
import 'package:guardian_keyper/src/message/domain/message_model.dart';

import '../../../domain/secret_shard_model.dart';
import '../../../domain/vault_interactor.dart';
import '../../presenters/vault_secret_presenter_base.dart';

export 'package:provider/provider.dart';

class VaultSecretAddPresenter extends VaultSecretPresenterBase {
  VaultSecretAddPresenter({
    required super.pages,
    required super.vaultId,
  }) : super(secretId: SecretId()) {
    _vaultInteractor.logStartAddSecret();
  }

  @override
  late final networkSubscription =
      _vaultInteractor.messageStream.listen(_onMessage);

  String get secret => _secret;

  bool get isSecretObscure => _isSecretObscure;

  bool get isNameTooShort => _secretName.length < minNameLength;

  void setSecret(final String value) {
    _secret = value;
    notifyListeners();
  }

  void setSecretName(final String value) {
    _secretName = value;
    notifyListeners();
  }

  void toggleIsSecretObscure() {
    _isSecretObscure = !_isSecretObscure;
    notifyListeners();
  }

  Future<MessageModel> startRequest() async {
    _splitSecret();
    networkSubscription.resume();
    await startNetworkRequest();
    return requestCompleter.future;
  }

  void _onMessage(final MessageModel incomeMessage) async {
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
                  .firstWhere((m) => m.ownerId == selfId)
                  .secretShard
                  .shard
              : '',
        );
        _vaultInteractor.logFinishAddSecret();
        requestCompleter.complete(message);
      }
    } else {
      stopListenResponse();
      requestCompleter.complete(message);
    }
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
          status: guardian == selfId
              ? MessageStatus.accepted
              : MessageStatus.created,
          payload: SecretShardModel(
            id: secretId,
            ownerId: selfId,
            vaultId: vault.id,
            groupSize: vault.size,
            groupThreshold: vault.threshold,
            shard: shardsIterator.current,
          ),
        ));
      }
    }
  }

  final _vaultInteractor = GetIt.I<VaultInteractor>();

  String _secretName = '', _secret = '';

  bool _isSecretObscure = true;
}
