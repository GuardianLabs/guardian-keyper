import 'package:get_it/get_it.dart';
import 'package:sss256/sss256.dart';

import 'package:guardian_keyper/src/core/consts.dart';
import 'package:guardian_keyper/src/core/domain/entity/core_model.dart';

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

  String get secret => _secret;

  bool get isSecretObscure => _isSecretObscure;

  bool get isNameTooShort => _secretName.length < minNameLength;

  @override
  Future<MessageModel> startRequest() {
    _splitSecret();
    return super.startRequest();
  }

  @override
  void responseHandler(final MessageModel message) async {
    if (message.code != MessageCode.setShard) return;
    final updatedMessage = checkAndUpdateMessage(message);
    if (updatedMessage == null) return;
    if (updatedMessage.isAccepted) {
      if (messages.where((m) => m.isAccepted).length == vault.maxSize) {
        stopListenResponse();
        await _vaultInteractor.addSecret(
          vault: vault,
          secretId: secretId,
          secretValue: vault.isSelfGuarded
              ? messages
                  .firstWhere((m) => m.ownerId == _vaultInteractor.selfId)
                  .secretShard
                  .shard
              : '',
        );
        _vaultInteractor.logFinishAddSecret();
        requestCompleter.complete(updatedMessage);
      }
    } else {
      stopListenResponse();
      requestCompleter.complete(updatedMessage);
    }
  }

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

  bool isMyself(final PeerId peerId) => peerId == _vaultInteractor.selfId;

  // Private
  final _vaultInteractor = GetIt.I<VaultInteractor>();

  String _secretName = '', _secret = '';

  bool _isSecretObscure = true;

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
          status: guardian == _vaultInteractor.selfId
              ? MessageStatus.accepted
              : MessageStatus.created,
          payload: SecretShardModel(
            id: secretId,
            ownerId: _vaultInteractor.selfId,
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
