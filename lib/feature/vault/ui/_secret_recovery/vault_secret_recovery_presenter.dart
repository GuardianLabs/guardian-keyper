import 'package:flutter/services.dart';

import 'package:guardian_keyper/feature/message/domain/entity/message_model.dart';
import 'package:guardian_keyper/feature/vault/domain/entity/secret_shard.dart';
import 'package:guardian_keyper/feature/vault/domain/use_case/vault_interactor.dart';
import 'package:guardian_keyper/feature/vault/ui/vault_secret_presenter_base.dart';

export 'package:provider/provider.dart';

final class VaultSecretRecoveryPresenter extends VaultSecretPresenterBase {
  VaultSecretRecoveryPresenter({
    required super.stepsCount,
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
        payload: SecretShard(
          id: secretId,
          ownerId: _vaultInteractor.selfId,
          vaultId: vaultId,
          vaultSize: vault.maxSize,
          vaultThreshold: vault.threshold,
          shard: guardian == vault.ownerId ? vault.secrets[secretId]! : '',
        ),
      ));
    }
    _vaultInteractor.logStartRestoreSecret();
  }

  final _vaultInteractor = GetIt.I<VaultInteractor>();

  String _secret = '';
  bool _isObfuscated = true;
  bool _isAuthorized = false;

  String get secret => _secret;

  bool get isObfuscated => _isObfuscated;

  int get needAtLeast => vault.threshold - (vault.isSelfGuarded ? 1 : 0);

  @override
  Future<void> responseHandler(MessageModel message) async {
    final updatedMessage = checkAndUpdateMessage(message, MessageCode.getShard);
    if (updatedMessage == null) return;
    if (messages.where((m) => m.isAccepted).length >= vault.threshold) {
      stopListenResponse();
      _vaultInteractor.logFinishRestoreSecret();
      _secret = await _vaultInteractor.restoreSecret(messages
          .where((e) => e.secretShard.shard.isNotEmpty)
          .map((e) => e.secretShard.shard)
          .toList());
      requestCompleter.complete(updatedMessage);
      nextPage();
    } else if (messages.where((e) => e.isRejected).length > vault.redudancy) {
      stopListenResponse();
      requestCompleter.complete(updatedMessage.copyWith(
        status: MessageStatus.rejected,
      ));
    } else {
      notifyListeners();
    }
  }

  void onPressedHide() {
    _isObfuscated = true;
    notifyListeners();
  }

  bool tryShow() {
    if (_isAuthorized) {
      _isObfuscated = false;
      notifyListeners();
      return true;
    }
    return false;
  }

  void onUnlockedShow() {
    _isObfuscated = false;
    _isAuthorized = true;
    notifyListeners();
  }

  Future<bool> tryCopy() async {
    if (!_isAuthorized) return false;
    try {
      await Clipboard.setData(ClipboardData(text: secret));
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> onUnlockedCopy() {
    _isAuthorized = true;
    notifyListeners();
    return tryCopy();
  }
}
