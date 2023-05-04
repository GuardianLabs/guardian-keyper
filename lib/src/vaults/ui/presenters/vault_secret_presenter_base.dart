import 'package:get_it/get_it.dart';

import 'package:guardian_keyper/src/core/domain/entity/core_model.dart';

import '../../domain/vault_interactor.dart';
import 'vault_presenter_base.dart';

abstract class VaultSecretPresenterBase extends VaultPresenterBase {
  VaultSecretPresenterBase({
    super.currentPage,
    required super.pages,
    required this.vaultId,
    required this.secretId,
  }) {
    vault = _vaultInteractor.getVaultById(vaultId)!;
  }

  SecretId secretId;
  final VaultId vaultId;
  late final VaultModel vault;
  final Set<MessageModel> messages = {};

  @override
  void callback([_]) {
    if (messages.where((m) => m.hasResponse).length == vault.maxSize) {
      stopListenResponse();
    } else {
      for (final message in messages.where((m) => m.hasNoResponse)) {
        _vaultInteractor.sendToGuardian(message);
      }
    }
  }

  MessageModel? checkAndUpdateMessage(final MessageModel message) {
    if (message.hasNoResponse) return null;
    final storedMessage = messages.lookup(message);
    if (storedMessage == null || storedMessage.hasResponse) return null;
    messages.remove(message);
    final updatedMessage = storedMessage.copyWith(
      status: message.status,
      payload: message.payload,
    );
    messages.add(updatedMessage);
    notifyListeners();
    return updatedMessage;
  }

  final _vaultInteractor = GetIt.I<VaultInteractor>();
}
