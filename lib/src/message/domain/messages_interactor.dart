import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

import '/src/core/consts.dart';
import '/src/vaults/data/vault_repository.dart';
import '/src/message/data/message_repository.dart';
import '/src/settings/data/settings_repository.dart';
import '/src/core/service/network/network_service.dart';

class MessagesInteractor {
  late final pingPeer = _networkService.pingPeer;
  late final getPeerStatus = _networkService.getPeerStatus;
  late final messageTTL = _networkService.messageTTL;

  PeerId get myPeerId => _networkService.myPeerId.copyWith(
        name: _settingsRepository.settings.deviceName,
      );

  Box<MessageModel> get messageRepository => _messageRepository; // TBD: remove?

  MessagesInteractor({
    NetworkService? networkService,
    VaultRepository? vaultRepository,
    MessageRepository? messageRepository,
    SettingsRepository? settingsRepository,
  })  : _networkService = networkService ?? GetIt.I<NetworkService>(),
        _vaultRepository = vaultRepository ?? GetIt.I<VaultRepository>(),
        _messageRepository = messageRepository ?? GetIt.I<MessageRepository>(),
        _settingsRepository =
            settingsRepository ?? GetIt.I<SettingsRepository>() {
    Future.delayed(const Duration(seconds: 1), _pruneMessages);
    _networkService.messageStream.listen(onMessage);
    _settingsRepository.stream.listen(_onSettingsChange);
  }

  final NetworkService _networkService;
  final VaultRepository _vaultRepository;
  final MessageRepository _messageRepository;
  final SettingsRepository _settingsRepository;

  void onMessage(MessageModel message) {
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
    _messageRepository.put(
      message.aKey,
      message.copyWith(status: MessageStatus.received),
    );
  }

  Future<void> sendCreateGroupResponse(final MessageModel request) async {
    await _sendResponse(request);
    if (request.isAccepted) {
      final vault = VaultModel(
        id: request.recoveryGroup.id,
        ownerId: request.peerId,
        maxSize: request.recoveryGroup.maxSize,
        threshold: request.recoveryGroup.threshold,
      );
      await _vaultRepository.put(vault.aKey, vault);
    }
    await archivateMessage(request);
  }

  Future<void> sendTakeGroupResponse(final MessageModel request) async {
    if (request.isAccepted) {
      final vault = _vaultRepository
          .get(request.recoveryGroup.aKey)!
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

  Future<void> sendSetShardResponse(final MessageModel request) async {
    if (request.isAccepted) {
      final vault = _vaultRepository.get(request.groupId.asKey)!;
      await _vaultRepository.put(
        request.groupId.asKey,
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

  Future<void> sendGetShardResponse(final MessageModel request) async {
    if (request.isAccepted) {
      final vault = _vaultRepository.get(request.groupId.asKey)!;
      await _sendResponse(
        request.copyWith(
            payload: SecretShardModel(
          id: request.secretShard.id,
          ownerId: vault.ownerId,
          groupId: vault.id,
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

  Future<void> archivateMessage(final MessageModel message) async {
    await _messageRepository.delete(message.aKey);
    await _messageRepository.put(
      message.timestamp.millisecondsSinceEpoch.toString(),
      message,
    );
  }

  Future<void> _sendResponse(final MessageModel message) =>
      _networkService.sendTo(
        isConfirmable: true,
        peerId: message.peerId,
        message: message.copyWith(peerId: myPeerId),
      );

  void _onSettingsChange(final SettingsEvent event) {
    if (event.key == SettingsRepositoryKeys.isBootstrapEnabled) {
      event.value.isBootstrapEnabled
          ? _networkService.addBootstrapServer(
              Envs.bsPeerId,
              ipV4: Envs.bsAddressV4,
              ipV6: Envs.bsAddressV6,
              port: Envs.bsPort,
            )
          : _networkService.removeBootstrapServer(Envs.bsPeerId);
    }
  }

  Future<void> _pruneMessages() async {
    if (_messageRepository.isEmpty) return;
    final expired = _messageRepository.values
        .where((e) =>
            e.isRequested &&
            (e.code == MessageCode.createGroup ||
                e.code == MessageCode.takeGroup) &&
            e.timestamp
                .isBefore(DateTime.now().subtract(const Duration(days: 1))))
        .toList(growable: false);
    await _messageRepository.deleteAll(expired.map((e) => e.aKey));
    await _messageRepository.compact();
  }
}
