part of 'vault_presenter.dart';

class VaultSecretPresenter extends VaultPresenterBase {
  SecretId secretId;
  final VaultId groupId;
  late final VaultModel group;
  final Set<MessageModel> messages = {};

  VaultSecretPresenter({
    required super.pages,
    super.currentPage,
    required this.groupId,
    required this.secretId,
  }) {
    group = getVaultById(groupId)!;
  }

  MessageModel? checkAndUpdateMessage(final MessageModel incomeMessage) {
    if (incomeMessage.hasNoResponse) return null;
    final storedMessage = messages.lookup(incomeMessage);
    if (storedMessage == null || storedMessage.hasResponse) return null;
    messages.remove(incomeMessage);
    final updatedMessage = storedMessage.copyWith(
      status: incomeMessage.status,
      payload: incomeMessage.payload,
    );
    messages.add(updatedMessage);
    notifyListeners();
    return updatedMessage;
  }

  void requestShards([_]) {
    if (messages.where((m) => m.hasResponse).length == group.maxSize) {
      stopListenResponse();
    } else {
      for (final message in messages.where((m) => m.hasNoResponse)) {
        sendToGuardian(message);
      }
    }
  }
}
