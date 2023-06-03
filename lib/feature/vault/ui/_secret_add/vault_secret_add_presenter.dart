import 'package:get_it/get_it.dart';

import 'package:guardian_keyper/consts.dart';
import 'package:guardian_keyper/domain/entity/peer_id.dart';
import 'package:guardian_keyper/feature/message/domain/entity/message_model.dart';

import '../../domain/entity/secret_id.dart';
import '../../domain/entity/secret_shard.dart';
import '../../domain/use_case/vault_interactor.dart';
import '../vault_secret_presenter_base.dart';

export 'package:provider/provider.dart';

class VaultSecretAddPresenter extends VaultSecretPresenterBase {
  VaultSecretAddPresenter({
    required super.pageCount,
    required super.vaultId,
  }) : super(secretId: SecretId()) {
    _vaultInteractor.logStartAddSecret();
  }

  String get secret => _secret;

  bool get isSecretObscure => _isSecretObscure;

  bool get isNameTooShort => _secretName.length < minNameLength;

  @override
  Future<MessageModel> startRequest() async {
    secretId = secretId.copyWith(name: _secretName);
    final shardsIterator = (await _vaultInteractor.splitSecret(
      threshold: vault.threshold,
      shares: vault.maxSize,
      secret: _secret,
    ))
        .iterator;

    /// fill messages with request
    for (final guardian in vault.guardians.keys) {
      if (shardsIterator.moveNext()) {
        messages.add(MessageModel(
          peerId: guardian,
          code: MessageCode.setShard,
          status: guardian == _vaultInteractor.selfId
              ? MessageStatus.accepted
              : MessageStatus.created,
          payload: SecretShard(
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
    return super.startRequest();
  }

  @override
  void responseHandler(MessageModel message) async {
    final updatedMessage = checkAndUpdateMessage(message, MessageCode.setShard);
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

  void setSecret(String value) {
    _secret = value;
    notifyListeners();
  }

  void setSecretName(String value) {
    _secretName = value;
    notifyListeners();
  }

  void toggleIsSecretObscure() {
    _isSecretObscure = !_isSecretObscure;
    notifyListeners();
  }

  bool isMyself(PeerId peerId) => peerId == _vaultInteractor.selfId;

  // Private
  final _vaultInteractor = GetIt.I<VaultInteractor>();

  String _secretName = '', _secret = '';

  bool _isSecretObscure = true;
}
