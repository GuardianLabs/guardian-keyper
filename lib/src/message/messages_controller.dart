import 'package:flutter/foundation.dart';

import '/src/core/service/service_root.dart';
import '/src/core/repository/repository_root.dart';

export '/src/core/model/core_model.dart';

class MessagesController {
  MessagesController() {
    _serviceRoot.networkService.messageStream.listen(onMessage);
    _repositoryRoot.settingsRepository.stream.listen(
      (settings) => _myPeerId = _myPeerId.copyWith(name: settings.deviceName),
    );
  }

  final _serviceRoot = GetIt.I<ServiceRoot>();
  final _repositoryRoot = GetIt.I<RepositoryRoot>();

  late final _vaultRepository = _repositoryRoot.vaultRepository;

  late var _myPeerId = PeerId(
    token: _serviceRoot.networkService.myId,
    name: _repositoryRoot.settingsRepository.state.deviceName,
  );

  void onMessage(MessageModel message) {
    final ticket = _repositoryRoot.messageRepository.get(message.aKey);
    if (kDebugMode) print('$message\n$ticket');

    switch (message.code) {
      case MessageCode.createGroup:
        if (message.isEmpty) return;
        // qrCode was not generated
        if (ticket == null) return;
        // qrCode was processed already
        if (message.isNotRequested) return;
        if (message.code != ticket.code) return;
        // group already exists
        if (_vaultRepository.containsKey(message.groupId.asKey)) return;
        break;

      case MessageCode.takeGroup:
        // qrCode was not generated
        if (ticket == null) return;
        // qrCode was processed already
        if (message.isNotRequested) return;
        if (message.code != ticket.code) return;
        message = message.copyWith(payload: ticket.payload);
        break;

      case MessageCode.setShard:
        if (message.isEmpty) return;
        // request already processed
        if (ticket != null) return;
        final recoveryGroup = _vaultRepository.get(message.groupId.asKey);
        // group does not exists
        if (recoveryGroup == null) return;
        // not owner
        if (recoveryGroup.ownerId != message.peerId) return;
        // already have this Secret
        if (recoveryGroup.secrets.containsKey(message.secretShard.id)) return;
        break;

      case MessageCode.getShard:
        if (message.isEmpty) return;
        // request already processed
        if (ticket != null) return;
        final recoveryGroup = _vaultRepository.get(message.groupId.asKey);
        // group does not exists
        if (recoveryGroup == null) return;
        // not owner
        if (recoveryGroup.ownerId != message.peerId) return;
        // Have no such Secret
        if (!recoveryGroup.secrets.containsKey(message.secretShard.id)) return;
        break;
    }
    _repositoryRoot.messageRepository.put(
      message.aKey,
      message.copyWith(status: MessageStatus.received),
    );
  }

  Future<bool> sendCreateGroupResponse(MessageModel request) async {
    final isDelivered = await _sendResponse(request);
    if (isDelivered) {
      if (request.isAccepted) {
        final recoveryGroup = RecoveryGroupModel(
          id: request.recoveryGroup.id,
          ownerId: request.peerId,
          maxSize: request.recoveryGroup.maxSize,
          threshold: request.recoveryGroup.threshold,
        );
        await _vaultRepository.put(recoveryGroup.aKey, recoveryGroup);
      }
      await archivateMessage(request);
    }
    return isDelivered;
  }

  Future<void> sendTakeGroupResponse(MessageModel request) async {
    if (request.isAccepted) {
      final recoveryGroup = _vaultRepository
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
      await _vaultRepository.put(
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
      final recoveryGroup = _vaultRepository.get(request.groupId.asKey)!;
      await _vaultRepository.put(
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
      final recoveryGroup = _vaultRepository.get(request.groupId.asKey)!;
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
    await _repositoryRoot.messageRepository.delete(message.aKey);
    await _repositoryRoot.messageRepository.put(
      message.timestamp.millisecondsSinceEpoch.toString(),
      message,
    );
  }

  Future<bool> _sendResponse(MessageModel message) async {
    try {
      await _serviceRoot.networkService.sendTo(
        isConfirmable: true,
        peerId: message.peerId,
        message: message.copyWith(peerId: _myPeerId),
      );
      return true;
    } catch (_) {
      return false;
    }
  }
}
