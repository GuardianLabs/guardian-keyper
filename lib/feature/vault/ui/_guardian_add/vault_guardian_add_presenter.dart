import 'package:get_it/get_it.dart';

import 'package:guardian_keyper/feature/message/domain/entity/message_model.dart';

import '../../domain/entity/vault_id.dart';
import '../../domain/use_case/vault_interactor.dart';
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

  @override
  MessageCode get messageCode => MessageCode.createGroup;

  @override
  void requestWorker([timer]) =>
      _vaultInteractor.sendToGuardian(_messageToSend);

  @override
  void responseHandler(MessageModel message) async {
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

  // Private
  final _vaultInteractor = GetIt.I<VaultInteractor>();

  late final _messageToSend = qrCode!.copyWith(
    payload: _vaultInteractor.getVaultById(vaultId),
  );
}
