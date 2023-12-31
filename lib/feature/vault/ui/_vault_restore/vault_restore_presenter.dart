import 'dart:async';

import 'package:guardian_keyper/feature/vault/domain/entity/vault_id.dart';
import 'package:guardian_keyper/feature/message/domain/entity/message_model.dart';
import 'package:guardian_keyper/feature/vault/domain/use_case/vault_interactor.dart';
import 'package:guardian_keyper/feature/vault/ui/vault_guardian_presenter_base.dart';

export 'package:provider/provider.dart';

export '../vault_guardian_presenter_base.dart';

final class VaultRestorePresenter extends VaultGuardianPresenterBase {
  VaultRestorePresenter({
    required super.pageCount,
    this.vaultId,
  }) {
    _vaultInteractor.logStartRestoreVault();
  }

  final _vaultInteractor = GetIt.I<VaultInteractor>();

  // TBD: check if vaultId is same as provided
  // should accept code only for given VaultId
  @override
  final VaultId? vaultId;

  @override
  MessageCode get messageCode => MessageCode.takeVault;

  @override
  void requestWorker([Timer? timer]) =>
      _vaultInteractor.sendToGuardian(qrCode!);

  @override
  Future<void> responseHandler(MessageModel message) async {
    if (isNotValidMessage(message, vaultId)) return;
    stopListenResponse();

    if (message.isNotAccepted) return requestCompleter.complete(message);

    final storedVault = _vaultInteractor.getVaultById(message.vaultId);

    // Vault does not exists
    if (storedVault == null) {
      _vaultInteractor.logFinishRestoreVault();
      return requestCompleter.complete(message.copyWith(
        payload: await _vaultInteractor.createVault(message.vault.copyWith(
          ownerId: _vaultInteractor.selfId,
          guardians: {qrCode!.peerId: ''},
        )),
      ));
    }

    // Vault is not in restoring mode
    if (storedVault.isNotRestricted) {
      return requestCompleter.complete(message.copyWith(
        status: MessageStatus.failed,
      ));
    }

    // Vault can add this Guardian
    if (storedVault.isNotFull) {
      requestCompleter.complete(message.copyWith(
        payload: await _vaultInteractor.addGuardian(
          vaultId: message.vaultId,
          guardian: qrCode!.peerId,
        ),
      ));
      _vaultInteractor.logFinishRestoreVault();
    }
  }
}
