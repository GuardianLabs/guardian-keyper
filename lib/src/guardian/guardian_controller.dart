import '/src/core/di_container.dart' show SettingsModelExt;
import '/src/core/controller/base_controller.dart';
import '/src/core/model/core_model.dart';

export 'package:provider/provider.dart';

class GuardianController extends BaseController {
  GuardianController({required super.diContainer}) {
    diContainer.networkService.guardianStream.listen(onMessage);
    _cleanMessageBox();
  }

  Iterable<MessageModel> get messages => diContainer.boxMessages.values;

  Iterable<MessageModel> get messagesProcessed =>
      diContainer.boxMessages.values.where((e) => e.isProcessed);

  Iterable<SecretShardModel> get secretShards =>
      diContainer.boxSecretShards.values;

  MessageModel? getMessageByKey(String? key) =>
      diContainer.boxMessages.get(key);

  SecretShardModel? getSecretShardByKey(String? key) =>
      diContainer.boxSecretShards.get(key);

  QRCode getQrCode([SecretShardModel? secretShard]) {
    final message = MessageModel(
      type: secretShard == null
          ? OperationType.authPeer
          : OperationType.takeOwnership,
      status: MessageStatus.started,
      nonce: Nonce.aNew(),
      secretShard: secretShard,
    );
    _putMessage(message);
    return QRCode(
      type: message.type,
      nonce: message.nonce,
      peerId: diContainer.networkService.myPeerId,
      peerName: diContainer.boxSettings.readWhole().deviceName,
      addresses: diContainer.networkService.myIPs,
    );
  }

  void onMessage(MessageModel message) {
    if (message.secretShard.isEmpty) return;
    final request = getMessageByKey(message.aKey);
    if (message.type != OperationType.getShard) {
      if (request == null ||
          request.type != message.type ||
          request.hasResponse) {
        diContainer.networkService.sendToRecoveryGroup(
            message.copyWith(status: MessageStatus.failed));
        return;
      }
      if (message.isProcessed) return;
    }

    switch (message.type) {
      case OperationType.authPeer:
        _putMessage(message.process(message.peerId));
        break;

      case OperationType.setShard:
        if (message.peerId != request!.secretShard.ownerId) return;
        _putMessage(message.process(message.peerId));
        break;

      case OperationType.getShard:
        final secretShard =
            diContainer.boxSecretShards.get(message.secretShard.asKey);
        if (secretShard?.ownerId != message.peerId) return;
        _putMessage(MessageModel(
          peerId: secretShard!.ownerId,
          type: OperationType.getShard,
          status: MessageStatus.processed,
          nonce: message.nonce,
          secretShard: secretShard,
        ));
        break;

      case OperationType.takeOwnership:
        _putMessage(request!.process(
          message.peerId,
          message.secretShard.ownerName,
        ));
        break;
    }
  }

  Future<void> sendAuthPeerResponse(MessageModel request) async {
    await diContainer.networkService.sendToRecoveryGroup(request);
    await _archiveMessage(request);
    await _putMessage(MessageModel(
      type: OperationType.setShard,
      status: MessageStatus.started,
      secretShard: request.secretShard.copyWith(ownerId: request.peerId),
    ));
  }

  Future<void> sendSetShardResponse(MessageModel request) async {
    if (request.isAccepted) {
      await diContainer.boxSecretShards
          .put(request.secretShard.asKey, request.secretShard);
    }
    request = request.clearSecret();
    await diContainer.networkService.sendToRecoveryGroup(request);
    await _archiveMessage(request);
  }

  Future<void> sendGetShardResponse(MessageModel request) async {
    request = request.copyWith();
    if (request.isRejected) request = request.clearSecret();
    await diContainer.networkService.sendToRecoveryGroup(request);
    await _archiveMessage(request);
  }

  Future<void> sendTakeOwnershipResponse(MessageModel request) async {
    await diContainer.networkService.sendToRecoveryGroup(request.clearSecret());
    if (request.isAccepted) {
      await diContainer.boxSecretShards.put(
        request.secretShard.asKey,
        request.secretShard,
      );
    }
    await _archiveMessage(request);
  }

  Future<void> archivateRequest(MessageModel request) async {
    if (!request.isProcessed) return;
    await _archiveMessage(request.copyWith(status: MessageStatus.rejected));
  }

  Future<void> removeShard(SecretShardModel secretShard) async {
    await diContainer.boxSecretShards.delete(secretShard.asKey);
    notifyListeners();
  }

  Future<void> _putMessage(MessageModel message) async {
    if (getMessageByKey(message.aKey) == message) return;
    await diContainer.boxMessages.put(message.aKey, message);
    if (message.isProcessed) {
      diContainer.eventBus.fire(NewMessageProcessedEvent(message: message));
    }
    notifyListeners();
  }

  Future<void> _archiveMessage(MessageModel message) async {
    await diContainer.boxMessages.delete(message.aKey);
    if (message.secretShard.value.isNotEmpty) message = message.clearSecret();
    await diContainer.boxMessages.put(
      message.timestamp.millisecondsSinceEpoch.toString(),
      message,
    );
    notifyListeners();
  }

  Future<void> _cleanMessageBox() async {
    if (diContainer.boxMessages.isEmpty) return;
    final expired = diContainer.boxMessages.values
        .where((e) =>
            e.isStarted &&
            (e.type == OperationType.authPeer ||
                e.type == OperationType.takeOwnership) &&
            e.timestamp
                .isBefore(DateTime.now().subtract(const Duration(days: 1))))
        .toList(growable: false);
    if (expired.isEmpty) return;
    await diContainer.boxMessages.deleteAll(expired.map((e) => e.aKey));
    await diContainer.boxMessages.compact();
  }
}
