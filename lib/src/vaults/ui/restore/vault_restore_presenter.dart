import '/src/core/data/core_model.dart';

import '../vault_presenter_base.dart';

export 'package:provider/provider.dart';

class VaultRestorePresenter extends VaultGuardianPresenterBase {
  // TBD: check if vaultId is same as provided
  final VaultId? vaultId;

  VaultRestorePresenter({required super.pages, this.vaultId});

  Future<void> startRequest({
    required Callback onSuccess,
    required Callback onReject,
    required Callback onDuplicate,
    required Callback onFail,
  }) async {
    logStartRestoreVault();
    networkSubscription.onData(
      (message) {
        if (!isWaiting) return;
        if (!message.hasResponse) return;
        if (message.code != MessageCode.takeGroup) return;
        if (qrCode == null || message.peerId != qrCode!.peerId) return;
        stopListenResponse();
        notifyListeners();
        if (message.isFailed) return onFail(message);
        if (message.isRejected) return onReject(message);

        if (message.isAccepted) {
          final guardian = qrCode!.peerId;
          final existingGroup = getVaultById(message.groupId);
          if (existingGroup == null) {
            logFinishRestoreVault();
            createGroup(message.recoveryGroup.copyWith(
              ownerId: myPeerId,
              guardians: {guardian: ''},
            )).then(
              (group) => onSuccess(message.copyWith(payload: group)),
            );
          } else if (existingGroup.isNotRestoring) {
            onFail(message);
          } else if (existingGroup.guardians.containsKey(guardian)) {
            onDuplicate(message);
          } else if (existingGroup.isNotFull) {
            logFinishRestoreVault();
            addGuardian(message.groupId, guardian).then(
              (group) => onSuccess(message.copyWith(payload: group)),
            );
          }
        }
      },
    );
    startNetworkRequest(([_]) => sendToGuardian(qrCode!));
  }
}
