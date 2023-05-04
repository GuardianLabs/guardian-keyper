import 'dart:async';
import 'package:get_it/get_it.dart';

import 'package:guardian_keyper/src/message/domain/message_model.dart';

import '../../presenters/vault_guardian_presenter_base.dart';
import '../../../domain/vault_interactor.dart';
import '../../../domain/vault_model.dart';

export 'package:provider/provider.dart';

export 'package:guardian_keyper/src/message/domain/message_model.dart';

export '../../presenters/vault_guardian_presenter_base.dart';

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
  late final networkSubscription =
      _vaultInteractor.messageStream.listen(_onMessage);

  @override
  MessageCode get messageCode => MessageCode.takeGroup;

  @override
  void callback([_]) => _vaultInteractor.sendToGuardian(qrCode!);

  Future<MessageModel> startRequest() async {
    networkSubscription.resume();
    await startNetworkRequest();
    return requestCompleter.future;
  }

  void _onMessage(final MessageModel message) async {
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
          message.vaultId,
          qrCode!.peerId,
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

  final _vaultInteractor = GetIt.I<VaultInteractor>();
}
