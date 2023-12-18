import 'dart:async';
import 'package:get_it/get_it.dart';

import 'package:guardian_keyper/feature/network/domain/entity/peer_id.dart';
import 'package:guardian_keyper/feature/message/domain/entity/message_model.dart';

import '../domain/use_case/vault_interactor.dart';
import '../domain/entity/secret_id.dart';
import '../domain/entity/vault_id.dart';
import 'vault_presenter_base.dart';

abstract class VaultSecretPresenterBase extends VaultPresenterBase {
  VaultSecretPresenterBase({
    required super.pageCount,
    required this.vaultId,
    required this.secretId,
    super.currentPage,
  });

  SecretId secretId;

  final VaultId vaultId;

  final Set<MessageModel> messages = {};

  late final vault = _vaultInteractor.getVaultById(vaultId)!;

  @override
  void requestWorker([Timer? timer]) {
    if (messages.where((m) => m.hasResponse).length == vault.maxSize) {
      stopListenResponse();
    } else {
      for (final message in messages.where((m) => m.hasNoResponse)) {
        _vaultInteractor.sendToGuardian(message);
      }
    }
  }

  MessageModel getMessageOf(PeerId guardian) =>
      messages.firstWhere((e) => e.peerId == guardian);

  MessageModel? checkAndUpdateMessage(MessageModel message, MessageCode code) {
    if (message.code != code) return null;
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

  // Private
  final _vaultInteractor = GetIt.I<VaultInteractor>();
}
