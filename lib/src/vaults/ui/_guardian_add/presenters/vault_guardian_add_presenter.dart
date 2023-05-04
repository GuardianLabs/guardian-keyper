import 'dart:async';
import 'package:get_it/get_it.dart';

import 'package:guardian_keyper/src/message/domain/message_model.dart';

import '../../../domain/vault_model.dart';
import '../../../domain/vault_interactor.dart';
import '../../presenters/vault_guardian_presenter_base.dart';

export 'package:provider/provider.dart';

export 'package:guardian_keyper/src/message/domain/message_model.dart';

export '../../presenters/vault_guardian_presenter_base.dart';

class VaultGuardianAddPresenter extends VaultGuardianPresenterBase {
  VaultGuardianAddPresenter({
    required super.pages,
    required this.vaultId,
  }) {
    _vaultInteractor.logStartAddGuardian();
  }

  @override
  final VaultId vaultId;

  @override
  late final networkSubscription =
      _vaultInteractor.messageStream.listen(_onMessage);

  @override
  MessageCode get messageCode => MessageCode.createGroup;

  @override
  void callback([_]) => _vaultInteractor.sendToGuardian(_messageToSend);

  Future<MessageModel> startRequest() async {
    networkSubscription.resume();
    await startNetworkRequest();
    return requestCompleter.future;
  }

  void _onMessage(final MessageModel message) async {
    if (isNotWaiting) return;
    if (qrCode == null) return;
    if (message.hasNoResponse) return;
    if (message.vaultId != vaultId) return;
    if (message.code != messageCode) return;
    if (message.peerId != qrCode!.peerId) return;
    if (message.version != MessageModel.currentVersion) return;
    stopListenResponse();
    if (message.isAccepted) {
      await _vaultInteractor.addGuardian(vaultId, message.peerId);
      _vaultInteractor.logFinishAddGuardian();
    }
    requestCompleter.complete(message);
  }

  final _vaultInteractor = GetIt.I<VaultInteractor>();

  late final _messageToSend = qrCode!.copyWith(
    payload: _vaultInteractor.getVaultById(vaultId),
  );
}
