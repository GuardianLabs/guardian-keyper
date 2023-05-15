import 'package:get_it/get_it.dart';
import 'package:flutter/foundation.dart';

import 'package:guardian_keyper/domain/entity/message_model.dart';
import 'package:guardian_keyper/feature/vault/data/vault_repository.dart';

import '../data/message_repository.dart';

mixin class MessageIngressMixin {
  void onMessage(MessageModel message) {
    final ticket = _messageRepository.get(message.aKey);
    if (kDebugMode) print('$message\n$ticket');

    switch (message.code) {
      case MessageCode.createGroup:
        if (message.payload == null) return;
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
        if (message.payload == null) return;
        // request already processed
        if (ticket != null) return;
        final vault = _vaultRepository.get(message.vaultId.asKey);
        // group does not exists
        if (vault == null) return;
        // not owner
        if (vault.ownerId != message.peerId) return;
        // already have this Secret
        if (vault.secrets.containsKey(message.secretShard.id)) return;
        break;

      case MessageCode.getShard:
        if (message.payload == null) return;
        // request already processed
        if (ticket != null) return;
        final vault = _vaultRepository.get(message.vaultId.asKey);
        // group does not exists
        if (vault == null) return;
        // not owner
        if (vault.ownerId != message.peerId) return;
        // Have no such Secret
        if (!vault.secrets.containsKey(message.secretShard.id)) return;
        break;
    }
    _messageRepository.put(
      message.aKey,
      message.copyWith(status: MessageStatus.received),
    );
  }

  // Private
  final _vaultRepository = GetIt.I<VaultRepository>();
  final _messageRepository = GetIt.I<MessageRepository>();
}
