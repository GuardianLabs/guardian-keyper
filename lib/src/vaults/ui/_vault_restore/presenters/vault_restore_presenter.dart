import 'package:get_it/get_it.dart';

import 'package:guardian_keyper/src/core/domain/entity/core_model.dart';

import '../../../domain/vault_interactor.dart';
import '../../vault_presenter_base.dart';

export 'package:provider/provider.dart';

class VaultRestorePresenter extends VaultPresenterBase {
  VaultRestorePresenter({required super.pages, this.vaultId});

  // TBD: check if vaultId is same as provided
  final VaultId? vaultId;

  MessageModel? get qrCode => _qrCode;

  set qrCode(MessageModel? value) {
    if (_qrCode != value) {
      _qrCode = value;
      if (_qrCode != null) nextPage();
    }
  }

  Future<void> startRequest({
    required Callback onSuccess,
    required Callback onDuplicate,
    required Callback onReject,
    required Callback onFail,
  }) async {
    networkSubscription.onData(
      (final MessageModel message) async {
        if (!isWaiting) return;
        if (!message.hasResponse) return;
        if (message.code != MessageCode.takeGroup) return;
        if (qrCode == null || message.peerId != qrCode!.peerId) return;

        stopListenResponse();
        if (message.isFailed) return onFail(message);
        if (message.isRejected) return onReject(message);

        if (message.isAccepted) {
          final guardian = qrCode!.peerId;
          final existingVault = _vaultInteractor.getVaultById(message.vaultId);
          if (existingVault == null) {
            final vault =
                await _vaultInteractor.createVault(message.vault.copyWith(
              ownerId: _vaultInteractor.selfId,
              guardians: {guardian: ''},
            ));
            onSuccess(message.copyWith(payload: vault));
            _vaultInteractor.logFinishRestoreVault();
          } else if (existingVault.isNotRestricted) {
            onFail(message);
          } else if (existingVault.guardians.containsKey(guardian)) {
            onDuplicate(message);
          } else if (existingVault.isNotFull) {
            final vault = await _vaultInteractor.addGuardian(
              message.vaultId,
              guardian,
            );
            onSuccess(message.copyWith(payload: vault));
            _vaultInteractor.logFinishRestoreVault();
          }
        }
      },
    );
    await startNetworkRequest(
        ([_]) => _vaultInteractor.sendToGuardian(qrCode!));
    _vaultInteractor.logStartRestoreVault();
  }

  final _vaultInteractor = GetIt.I<VaultInteractor>();

  MessageModel? _qrCode;
}
