part of 'vault_presenter_base.dart';

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

  late final addSecret = _vaultInteractor.addSecret;

  late final vibrate = _vaultInteractor.vibrate;
  late final localAuthenticate = _vaultInteractor.localAuthenticate;

  late final logStartAddSecret = _vaultInteractor.logStartAddSecret;
  late final logFinishAddSecret = _vaultInteractor.logFinishAddSecret;

  late final logStartRestoreSecret = _vaultInteractor.logStartRestoreSecret;
  late final logFinishRestoreSecret = _vaultInteractor.logFinishRestoreSecret;

  PeerId get myPeerId => _vaultInteractor.selfId;

  String get passCode => _vaultInteractor.passCode;

  bool get useBiometrics => _vaultInteractor.useBiometrics;

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
    if (messages.where((m) => m.hasResponse).length == vault.maxSize) {
      stopListenResponse();
    } else {
      for (final message in messages.where((m) => m.hasNoResponse)) {
        _vaultInteractor.sendToGuardian(message);
      }
    }
  }
}
