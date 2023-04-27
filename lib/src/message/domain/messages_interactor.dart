import 'package:get_it/get_it.dart';
import 'package:flutter/foundation.dart';

import 'package:guardian_keyper/src/core/data/network_manager.dart';
import 'package:guardian_keyper/src/vaults/data/vault_repository.dart';
import 'package:guardian_keyper/src/settings/data/settings_manager.dart';

import '../data/message_repository.dart';

class MessagesInteractor {
  late final messageTTL = _networkManager.messageTTL;

  late final pingPeer = _networkManager.pingPeer;
  late final getPeerStatus = _networkManager.getPeerStatus;

  late final watchMessages = _messageRepository.watch;

  PeerId get selfId => _settingsManager.selfId;

  Iterable<MessageModel> get messages => _messageRepository.values;

  final _networkManager = GetIt.I<NetworkManager>();
  final _settingsManager = GetIt.I<SettingsManager>();
  final _vaultRepository = GetIt.I<VaultRepository>();
  final _messageRepository = GetIt.I<MessageRepository>();

  late final _subscription = _networkManager.messageStream.listen(_onMessage);

  Future<void> start() async {
    _subscription.resume();
  }

  Future<void> pause() {
    return _messageRepository.flush();
  }

  Future<void> stop() {
    return _subscription.cancel();
  }

  /// Create ticket to join vault
  Future<MessageModel> createJoinVaultCode() async {
    final message = MessageModel(
      code: MessageCode.createGroup,
      peerId: _settingsManager.selfId,
    );
    await _messageRepository.put(message.aKey, message);
    return message;
  }

  /// Create ticket to take vault
  Future<MessageModel> createTakeVaultCode(final VaultId? groupId) async {
    final message = MessageModel(
      code: MessageCode.takeGroup,
      peerId: _settingsManager.selfId,
    );
    await _messageRepository.put(
      message.aKey,
      message.copyWith(
        payload: VaultModel(id: groupId, ownerId: PeerId.empty),
      ),
    );
    return message;
  }

  Future<void> sendRespone(final MessageModel response) {
    switch (response.code) {
      case MessageCode.createGroup:
        return _sendCreateGroupResponse(response);
      case MessageCode.setShard:
        return _sendSetShardResponse(response);
      case MessageCode.getShard:
        return _sendGetShardResponse(response);
      case MessageCode.takeGroup:
        return _sendTakeGroupResponse(response);
    }
  }

  Future<void> archivateMessage(final MessageModel message) async {
    await _messageRepository.delete(message.aKey);
    await _messageRepository.put(
      message.timestamp.millisecondsSinceEpoch.toString(),
      message,
    );
  }

  void _onMessage(MessageModel message) {
    final ticket = _messageRepository.get(message.aKey);
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
        if (_vaultRepository.containsKey(message.vaultId.asKey)) return;
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
        final recoveryGroup = _vaultRepository.get(message.vaultId.asKey);
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
        final recoveryGroup = _vaultRepository.get(message.vaultId.asKey);
        // group does not exists
        if (recoveryGroup == null) return;
        // not owner
        if (recoveryGroup.ownerId != message.peerId) return;
        // Have no such Secret
        if (!recoveryGroup.secrets.containsKey(message.secretShard.id)) return;
        break;
    }
    _messageRepository.put(
      message.aKey,
      message.copyWith(status: MessageStatus.received),
    );
  }

  Future<void> _sendCreateGroupResponse(final MessageModel request) async {
    await _sendResponse(request);
    if (request.isAccepted) {
      final vault = VaultModel(
        id: request.vault.id,
        ownerId: request.peerId,
        maxSize: request.vault.maxSize,
        threshold: request.vault.threshold,
      );
      await _vaultRepository.put(vault.aKey, vault);
    }
    await archivateMessage(request);
  }

  Future<void> _sendTakeGroupResponse(final MessageModel request) async {
    if (request.isAccepted) {
      final vault = _vaultRepository
          .get(request.vault.aKey)!
          .copyWith(ownerId: request.peerId);
      await _sendResponse(request.copyWith(
        payload: vault.copyWith(
          secrets: {for (final secretId in vault.secrets.keys) secretId: ''},
        ),
      ));
      await _vaultRepository.put(vault.aKey, vault);
    } else {
      await _sendResponse(request.copyWith(emptyPayload: true));
    }
    await archivateMessage(request);
  }

  Future<void> _sendSetShardResponse(final MessageModel request) async {
    if (request.isAccepted) {
      final vault = _vaultRepository.get(request.vaultId.asKey)!;
      await _vaultRepository.put(
        request.vaultId.asKey,
        vault.copyWith(secrets: {
          ...vault.secrets,
          request.secretShard.id: request.secretShard.shard,
        }),
      );
    }
    await _sendResponse(request.copyWith(emptyPayload: true));
    await archivateMessage(request.copyWith(
      payload: request.secretShard.copyWith(shard: ''),
    ));
  }

  Future<void> _sendGetShardResponse(final MessageModel request) async {
    if (request.isAccepted) {
      final vault = _vaultRepository.get(request.vaultId.asKey)!;
      await _sendResponse(
        request.copyWith(
            payload: SecretShardModel(
          id: request.secretShard.id,
          ownerId: vault.ownerId,
          vaultId: vault.id,
          groupSize: vault.maxSize,
          groupThreshold: vault.threshold,
          shard: vault.secrets[request.secretShard.id]!,
        )),
      );
    } else {
      await _sendResponse(request.copyWith(emptyPayload: true));
    }
    await archivateMessage(request);
  }

  Future<void> _sendResponse(final MessageModel message) =>
      _networkManager.sendTo(
        isConfirmable: true,
        peerId: message.peerId,
        message: message.copyWith(peerId: _settingsManager.selfId),
      );
}
