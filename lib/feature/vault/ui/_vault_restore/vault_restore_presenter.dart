// ignore_for_file: parameter_assignments

import 'dart:async';

import 'package:guardian_keyper/feature/message/domain/entity/message_model.dart';

import '../../domain/entity/vault_id.dart';
import '../../domain/use_case/vault_interactor.dart';
import '../vault_guardian_presenter_base.dart';

export 'package:provider/provider.dart';

export '../vault_guardian_presenter_base.dart';

class VaultRestorePresenter extends VaultGuardianPresenterBase {
  VaultRestorePresenter({
    required super.pageCount,
    this.vaultId,
  }) {
    _vaultInteractor.logStartRestoreVault();
  }

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

    if (message.isAccepted) {
      final vault = _vaultInteractor.getVaultById(message.vaultId);
      // Vault does not exists
      if (vault == null) {
        message = message.copyWith(
          payload: await _vaultInteractor.createVault(message.vault.copyWith(
            ownerId: _vaultInteractor.selfId,
            guardians: {qrCode!.peerId: ''},
          )),
        );
        _vaultInteractor.logFinishRestoreVault();
        // Vault is not in restoring mode
      } else if (vault.isNotRestricted) {
        message = message.copyWith(status: MessageStatus.failed);
        // Vault can add this Guardian
      } else if (vault.isNotFull) {
        message = message.copyWith(
          payload: await _vaultInteractor.addGuardian(
            vaultId: message.vaultId,
            guardian: qrCode!.peerId,
          ),
        );
        _vaultInteractor.logFinishRestoreVault();
      }
    }
    requestCompleter.complete(message);
  }

  // Private
  final _vaultInteractor = GetIt.I<VaultInteractor>();
}
