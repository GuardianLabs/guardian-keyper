import 'package:guardian_keyper/consts.dart';
import 'package:guardian_keyper/data/repositories/settings_repository.dart';

import 'package:guardian_keyper/feature/message/domain/entity/message_model.dart';
import 'package:guardian_keyper/feature/vault/domain/entity/secret_id.dart';
import 'package:guardian_keyper/feature/vault/domain/entity/secret_shard.dart';
import 'package:guardian_keyper/feature/vault/domain/use_case/vault_interactor.dart';
import 'package:guardian_keyper/feature/vault/ui/vault_secret_presenter_base.dart';

export 'package:provider/provider.dart';

final class VaultSecretAddPresenter extends VaultSecretPresenterBase {
  VaultSecretAddPresenter({
    required super.stepsCount,
    required super.vaultId,
  }) : super(secretId: SecretId()) {
    _vaultInteractor.logStartAddSecret();
    _settingsRepository
        .get<bool>(PreferencesKeys.keyIsUnderstandingShardsHidden)
        .then((value) => _isUnderstandingShardsHidden = value ?? false);
  }

  final _vaultInteractor = GetIt.I<VaultInteractor>();
  final _settingsRepository = GetIt.I<SettingsRepository>();

  String _secret = '';
  String _secretName = '';
  bool _isUnderstandingShardsHidden = false;

  String get secret => _secret;

  String get secretName => _secretName;

  bool get isNameTooShort => _secretName.length < minNameLength;

  bool get isUnderstandingShardsHidden => _isUnderstandingShardsHidden;

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
            vaultSize: vault.size,
            vaultThreshold: vault.threshold,
            shard: shardsIterator.current,
          ),
        ));
      }
    }
    return super.startRequest();
  }

  @override
  Future<void> responseHandler(MessageModel message) async {
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
}
