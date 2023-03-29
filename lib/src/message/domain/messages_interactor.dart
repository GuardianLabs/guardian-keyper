import 'package:flutter/foundation.dart';

import '/src/core/consts.dart';
import '/src/core/service/service_root.dart';
import '/src/core/data/repository_root.dart';

export '/src/core/data/repository_root.dart';

// TBD: move state out from here
class MessagesInteractor {
  late final pingPeer = _serviceRoot.networkService.pingPeer;
  late final getPeerStatus = _serviceRoot.networkService.getPeerStatus;
  late final messageTTL = _serviceRoot.networkService.messageTTL;
  late final messagesUpdatesSubscription =
      _repositoryRoot.messageRepository.watch().listen(null);

  PeerId get myPeerId => _myPeerId;

  Box<MessageModel> get messageRepository => _repositoryRoot.messageRepository;

  MessagesInteractor({
    ServiceRoot? serviceRoot,
    RepositoryRoot? repositoryRoot,
  })  : _serviceRoot = serviceRoot ?? GetIt.I<ServiceRoot>(),
        _repositoryRoot = repositoryRoot ?? GetIt.I<RepositoryRoot>() {
    Future.delayed(const Duration(seconds: 1), _pruneMessages);
    _serviceRoot.networkService.messageStream.listen(onMessage);
    _repositoryRoot.settingsRepository.stream.listen(_onSettingsChange);
  }

  final ServiceRoot _serviceRoot;
  final RepositoryRoot _repositoryRoot;

  late final _vaultRepository = _repositoryRoot.vaultRepository;

  late var _myPeerId = _serviceRoot.networkService.myPeerId.copyWith(
    name: _repositoryRoot.settingsRepository.deviceName,
  );

  Future<void> dispose() async {
    await messagesUpdatesSubscription.cancel();
  }

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
      await _sendResponse(request.copyWith(payload: null));
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
    await _sendResponse(request.copyWith(payload: null));
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
      await _sendResponse(request.copyWith(payload: null));
    }
    await archivateMessage(request);
  }

  Future<void> archivateMessage(final MessageModel message) async {
    await _repositoryRoot.messageRepository.delete(message.aKey);
    await _repositoryRoot.messageRepository.put(
      message.timestamp.millisecondsSinceEpoch.toString(),
      message,
    );
  }

  Future<void> _sendResponse(final MessageModel message) =>
      _serviceRoot.networkService.sendTo(
        isConfirmable: true,
        peerId: message.peerId,
        message: message.copyWith(peerId: _myPeerId),
      );

  void _onSettingsChange(final MapEntry event) {
    if (event.key == SettingsRepositoryKeys.deviceName) {
      _myPeerId = _myPeerId.copyWith(name: event.value as String);
    } else if (event.key == SettingsRepositoryKeys.isBootstrapEnabled) {
      event.value == true
          ? _serviceRoot.networkService.addBootstrapServer(
              Envs.bsPeerId,
              ipV4: Envs.bsAddressV4,
              ipV6: Envs.bsAddressV6,
              port: Envs.bsPort,
            )
          : _serviceRoot.networkService.removeBootstrapServer(Envs.bsPeerId);
    }
  }

  // TBD: move to repository
  Future<void> _pruneMessages() async {
    if (_repositoryRoot.messageRepository.isEmpty) return;
    final expired = _repositoryRoot.messageRepository.values
        .where((e) =>
            e.isRequested &&
            (e.code == MessageCode.createGroup ||
                e.code == MessageCode.takeGroup) &&
            e.timestamp
                .isBefore(DateTime.now().subtract(const Duration(days: 1))))
        .toList(growable: false);
    await _repositoryRoot.messageRepository
        .deleteAll(expired.map((e) => e.aKey));
    await _repositoryRoot.messageRepository.compact();
  }
}
