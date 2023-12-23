import 'dart:async';

import 'package:guardian_keyper/feature/vault/domain/entity/vault_id.dart';
import 'package:guardian_keyper/feature/vault/domain/use_case/vault_interactor.dart';
import 'package:guardian_keyper/feature/message/domain/entity/message_model.dart';

import '../vault_guardian_presenter_base.dart';

export 'package:provider/provider.dart';

export '../vault_guardian_presenter_base.dart';

class VaultGuardianAddPresenter extends VaultGuardianPresenterBase {
  VaultGuardianAddPresenter({
    required super.pageCount,
    required this.vaultId,
  }) {
    _vaultInteractor.logStartAddGuardian();
  }

  @override
  final VaultId vaultId;

  final _vaultInteractor = GetIt.I<VaultInteractor>();

  late final _messageToSend = qrCode!.copyWith(
    payload: _vaultInteractor.getVaultById(vaultId),
  );

  @override
  MessageCode get messageCode => MessageCode.createVault;

  @override
  void requestWorker([Timer? timer]) =>
      _vaultInteractor.sendToGuardian(_messageToSend);

  @override
  Future<void> responseHandler(MessageModel message) async {
    if (isNotValidMessage(message, vaultId)) return;
    stopListenResponse();
    if (message.isAccepted) {
      await _vaultInteractor.addGuardian(
        vaultId: vaultId,
        guardian: message.peerId,
      );
      _vaultInteractor.logFinishAddGuardian();
    }
    requestCompleter.complete(message);
  }
}
