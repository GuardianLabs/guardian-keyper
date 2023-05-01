import 'package:get_it/get_it.dart';

import 'package:guardian_keyper/src/core/consts.dart';
import 'package:guardian_keyper/src/core/domain/entity/core_model.dart';

import '../../presenters/vault_presenter_base.dart';
import '../../presenters/qr_code_mixin.dart';
import '../../../domain/vault_interactor.dart';

export 'package:provider/provider.dart';

class VaultGuardianAddPresenter extends VaultPresenterBase with QrCodeMixin {
  VaultGuardianAddPresenter({required super.pages, required this.vaultId});

  final VaultId vaultId;

  @override
  MessageCode get messageCode => MessageCode.createGroup;

  Future<void> startRequest({
    required Callback onSuccess,
    required Callback onReject,
    required Callback onFail,
    required Callback onDuplicate,
    required Callback onAppVersion,
  }) async {
    _vaultInteractor.logStartAddGuardian();

    if (qrCode == null ||
        qrCode!.timestamp.subtract(qrCodeExpires).isAfter(DateTime.now())) {
      return onFail(qrCode!);
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
        if (message.code != messageCode) return;
        if (message.peerId != qrCode!.peerId) return;
        if (message.vaultId != vaultId) return;
        stopListenResponse();
        switch (message.status) {
          case MessageStatus.accepted:
            _vaultInteractor.logFinishAddGuardian();
            _vaultInteractor.addGuardian(vaultId, message.peerId);
            onSuccess(message);
            break;
          case MessageStatus.rejected:
            onReject(message);
            break;
          case MessageStatus.failed:
            onFail(message);
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
