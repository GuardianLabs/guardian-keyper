import 'package:get_it/get_it.dart';

import '../../../core/consts.dart';
import '../../../core/domain/entity/core_model.dart';

import '../../domain/vault_interactor.dart';
import '../vault_presenter_base.dart';

export 'package:provider/provider.dart';

class VaultAddGuardianPresenter extends VaultGuardianPresenterBase {
  final VaultId vaultId;

  VaultAddGuardianPresenter({required super.pages, required this.vaultId});

  Future<void> startRequest({
    required Callback onSuccess,
    required Callback onRejected,
    required Callback onFailed,
    required Callback onDuplicate,
    required Callback onAppVersion,
  }) async {
    logStartAddGuardian();

    if (qrCode == null ||
        qrCode!.timestamp.subtract(qrCodeExpires).isAfter(DateTime.now())) {
      return onFailed(qrCode!);
    }
    if (qrCode!.version != MessageModel.currentVersion) {
      return onAppVersion(qrCode!);
    }
    if (_vaultInteractor
            .getVaultById(vaultId)
            ?.guardians
            .containsKey(qrCode?.peerId) ??
        false) {
      return onDuplicate(qrCode!);
    }

    networkSubscription.onData(
      (final MessageModel message) {
        if (!isWaiting) return;
        if (qrCode == null) return;
        if (message.hasNoResponse) return;
        if (message.code != MessageCode.createGroup) return;
        if (message.peerId != qrCode!.peerId) return;
        if (message.vaultId != vaultId) return;
        stopListenResponse();
        switch (message.status) {
          case MessageStatus.accepted:
            logFinishAddGuardian();
            addGuardian(vaultId, message.peerId);
            onSuccess(message);
            break;
          case MessageStatus.rejected:
            onRejected(message);
            break;
          case MessageStatus.failed:
            onFailed(message);
            break;
          default:
        }
      },
    );

    startNetworkRequest(([_]) {
      _vaultInteractor.sendToGuardian(qrCode!.copyWith(
        payload: _vaultInteractor.getVaultById(vaultId),
      ));
    });
  }

  final _vaultInteractor = GetIt.I<VaultInteractor>();
}
