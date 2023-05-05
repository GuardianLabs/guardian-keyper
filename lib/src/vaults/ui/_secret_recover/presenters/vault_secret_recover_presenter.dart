import 'package:get_it/get_it.dart';
import 'package:sss256/sss256.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  String get secret => _secret;

  bool get isObfuscated => _isObfuscated;

  int get needAtLeast => vault.threshold - (vault.isSelfGuarded ? 1 : 0);

  @override
  void responseHandler(final MessageModel message) async {
    if (message.code != MessageCode.getShard) return;
    final updatedMessage = checkAndUpdateMessage(message);
    if (updatedMessage == null) return;
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

  void onPressedShow({required final BuildContext context}) {
    if (_isAuthorized) {
      _isObfuscated = false;
      notifyListeners();
    } else {
      _checkPassCode(
        context: context,
        onUnlocked: () {
          _isObfuscated = false;
          _isAuthorized = true;
          notifyListeners();
        },
      );
    }
  }

  void onPressedCopy({
    required final BuildContext context,
    required final SnackBar snackBar,
  }) async {
    if (_isAuthorized) {
      await Clipboard.setData(ClipboardData(text: secret));
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } else {
      _checkPassCode(
        context: context,
        onUnlocked: () async {
          _isAuthorized = true;
          notifyListeners();
          await Clipboard.setData(ClipboardData(text: secret));
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
      );
    }
  }

  // Private
  final _vaultInteractor = GetIt.I<VaultInteractor>();

  String _secret = '';
  bool _isObfuscated = true;
  bool _isAuthorized = false;

  Future<void> _checkPassCode({
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
}
