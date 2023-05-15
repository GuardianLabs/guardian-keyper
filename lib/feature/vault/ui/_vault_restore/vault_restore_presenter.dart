import 'package:get_it/get_it.dart';

import 'package:guardian_keyper/domain/entity/_id/vault_id.dart';
import 'package:guardian_keyper/domain/entity/message_model.dart';

import '../../domain/vault_interactor.dart';
import '../vault_guardian_presenter_base.dart';

export 'package:provider/provider.dart';

export '../vault_guardian_presenter_base.dart';

class VaultRestorePresenter extends VaultGuardianPresenterBase {
  VaultRestorePresenter({
    required super.pages,
    this.vaultId,
  }) {
    _vaultInteractor.logStartRestoreVault();
  }

  // TBD: check if vaultId is same as provided
  // should accept code only for given VaultId
  @override
  final VaultId? vaultId;

  @override
  MessageCode get messageCode => MessageCode.takeGroup;

  @override
  void requestWorker([timer]) => _vaultInteractor.sendToGuardian(qrCode!);

  @override
  void responseHandler(MessageModel message) async {
    if (isNotWaiting) return;
    if (qrCode == null) return;
    if (!message.hasResponse) return;
    if (message.code != messageCode) return;
    if (message.peerId != qrCode!.peerId) return;
    if (message.version != MessageModel.currentVersion) return;
    stopListenResponse();

    if (message.isAccepted) {
      final existingVault = _vaultInteractor.getVaultById(message.vaultId);
      if (existingVault == null) {
        final vault = await _vaultInteractor.createVault(message.vault.copyWith(
          ownerId: _vaultInteractor.selfId,
          guardians: {qrCode!.peerId: ''},
        ));
        _vaultInteractor.logFinishRestoreVault();
        requestCompleter.complete(message.copyWith(
          payload: vault,
        ));
        return;
      } else if (existingVault.isNotRestricted) {
        requestCompleter.complete(message.copyWith(
          status: MessageStatus.failed,
        ));
        return;
      } else if (existingVault.isNotFull) {
        final vault = await _vaultInteractor.addGuardian(
          vaultId: message.vaultId,
          guardian: qrCode!.peerId,
        );
        _vaultInteractor.logFinishRestoreVault();
        requestCompleter.complete(message.copyWith(
          payload: vault,
        ));
        return;
      }
    }
    requestCompleter.complete(message);
  }

  // Private
  final _vaultInteractor = GetIt.I<VaultInteractor>();
}
