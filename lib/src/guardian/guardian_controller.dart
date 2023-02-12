import '/src/core/di_container.dart';
import '/src/core/model/core_model.dart';

export 'package:provider/provider.dart';

class GuardianController {
  final DIContainer diContainer;

  GuardianController({required this.diContainer}) {
    diContainer.networkService.messageStream.listen(onMessage);
    _cleanMessageBox();
  }

  /// Create ticket to create\take group
  MessageModel generateQrCode([GroupId? groupId]) {
    final message = groupId == null
        ? MessageModel(code: MessageCode.createGroup)
        : MessageModel(
            code: MessageCode.takeGroup,
            payload: RecoveryGroupModel(id: groupId),
          );
    // save groupId for transaction
    diContainer.boxMessages.put(message.aKey, message);
    return message.copyWith(
      peerId: diContainer.myPeerId,
      payload: PeerAddressList(
        addresses: diContainer.networkService.myAddresses,
      ),
    );
  }

  void onMessage(MessageModel message) {
    if (message.isEmpty) return;
    final ticket = diContainer.boxMessages.get(message.aKey);

    switch (message.code) {
      case MessageCode.createGroup:
        if (ticket == null) return; // qrCode was not generated
        if (message.isNotRequested) return; // qrCode was processed already
        if (message.code != ticket.code) return;
        if (diContainer.boxRecoveryGroups.containsKey(message.groupId.asKey)) {
          return; // group already exists
        }
        break;

      case MessageCode.takeGroup:
        if (ticket == null) return; // qrCode was not generated
        if (message.isNotRequested) return; // qrCode was processed already
        if (message.code != ticket.code) return;
        message = message.copyWith(payload: ticket.payload);
        break;

      case MessageCode.setShard:
        if (ticket != null) return; // request already processed
        final recoveryGroup =
            diContainer.boxRecoveryGroups.get(message.groupId.asKey);
        if (recoveryGroup == null) return; // group does not exists
        if (recoveryGroup.ownerId != message.peerId) return; // not owner
        // already have this Secret
        if (recoveryGroup.secrets.containsKey(message.secretShard.id)) return;
        break;

      case MessageCode.getShard:
        if (ticket != null) return; // request already processed
        final recoveryGroup =
            diContainer.boxRecoveryGroups.get(message.groupId.asKey);
        if (recoveryGroup == null) return; // group does not exists
        if (recoveryGroup.ownerId != message.peerId) return; // not owner
        // Have no such Secret
        if (!recoveryGroup.secrets.containsKey(message.secretShard.id)) return;
        break;
    }
    diContainer.boxMessages.put(
      message.aKey,
      message.copyWith(status: MessageStatus.received),
    );
  }

  Future<void> sendCreateGroupResponse(MessageModel request) async {
    if (request.isAccepted) {
      final recoveryGroup = RecoveryGroupModel(
        id: request.recoveryGroup.id,
        ownerId: request.peerId,
        maxSize: request.recoveryGroup.maxSize,
        threshold: request.recoveryGroup.threshold,
      );
      await diContainer.boxRecoveryGroups
          .put(recoveryGroup.aKey, recoveryGroup);
    }
    await _sendResponse(request.copyWith(payload: null));
    await archivateMessage(request);
  }

  Future<void> sendTakeGroupResponse(MessageModel request) async {
    if (request.isAccepted) {
      final recoveryGroup = diContainer.boxRecoveryGroups
          .get(request.recoveryGroup.aKey)!
          .copyWith(ownerId: request.peerId);
      await _sendResponse(
        request.copyWith(
          payload: recoveryGroup.copyWith(
            secrets: {
              for (final secretId in recoveryGroup.secrets.keys) secretId: ''
            },
          ),
        ),
      );
      await diContainer.boxRecoveryGroups.put(
        recoveryGroup.aKey,
        recoveryGroup,
      );
    } else {
      await _sendResponse(request.copyWith(payload: null));
    }
    await archivateMessage(request);
  }

  Future<void> sendSetShardResponse(MessageModel request) async {
    if (request.isAccepted) {
      final recoveryGroup =
          diContainer.boxRecoveryGroups.get(request.groupId.asKey)!;
      await diContainer.boxRecoveryGroups.put(
        request.groupId.asKey,
        recoveryGroup.copyWith(secrets: {
          ...recoveryGroup.secrets,
          request.secretShard.id: request.secretShard.shard,
        }),
      );
    }
    await _sendResponse(request.copyWith(payload: null));
    await archivateMessage(request.copyWith(
      payload: (request.payload as SecretShardModel).copyWith(shard: ''),
    ));
  }

  Future<void> sendGetShardResponse(MessageModel request) async {
    if (request.isAccepted) {
      final recoveryGroup =
          diContainer.boxRecoveryGroups.get(request.groupId.asKey)!;
      await _sendResponse(
        request.copyWith(
          payload: SecretShardModel(
            id: request.secretShard.id,
            ownerId: recoveryGroup.ownerId,
            groupId: recoveryGroup.id,
            groupSize: recoveryGroup.maxSize,
            groupThreshold: recoveryGroup.threshold,
            shard: recoveryGroup.secrets[request.secretShard.id]!,
          ),
        ),
      );
    } else {
      await _sendResponse(request.copyWith(payload: null));
    }
    await archivateMessage(request);
  }

  Future<void> archivateMessage(MessageModel message) async {
    await diContainer.boxMessages.delete(message.aKey);
    await diContainer.boxMessages.put(
      message.timestamp.millisecondsSinceEpoch.toString(),
      message,
    );
  }

  Future<void> _sendResponse(MessageModel message) =>
      diContainer.networkService.sendTo(
        isConfirmable: true,
        peerId: message.peerId,
        message: message.copyWith(peerId: diContainer.myPeerId),
      );

  Future<void> _cleanMessageBox() async {
    if (diContainer.boxMessages.isEmpty) return;
    final expired = diContainer.boxMessages.values
        .where((e) =>
            e.isRequested &&
            (e.code == MessageCode.createGroup ||
                e.code == MessageCode.takeGroup) &&
            e.timestamp
                .isBefore(DateTime.now().subtract(const Duration(days: 1))))
        .toList(growable: false);
    await diContainer.boxMessages.deleteAll(expired.map((e) => e.aKey));
    await diContainer.boxMessages.compact();
  }
}
