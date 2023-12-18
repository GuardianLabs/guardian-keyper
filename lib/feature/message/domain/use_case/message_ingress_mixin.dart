import 'package:get_it/get_it.dart';
import 'package:flutter/foundation.dart';

import 'package:guardian_keyper/feature/vault/data/vault_repository.dart';

import '../../data/message_repository.dart';
import '../entity/message_model.dart';

mixin class MessageIngressMixin {
  void onMessage(MessageModel message) {
    final ticket = _messageRepository.get(message.aKey);
    if (kDebugMode) print('$message\n$ticket');

    switch (message.code) {
      case MessageCode.createVault:
        if (message.payload == null) return;
        // qrCode was not generated
        if (ticket == null) return;
        // qrCode was processed already
        if (message.isNotRequested) return;
        if (message.code != ticket.code) return;
        // vault already exists
        if (_vaultRepository.containsKey(message.vaultId.asKey)) return;

      case MessageCode.takeVault:
        // qrCode was not generated
        if (ticket == null) return;
        // qrCode was processed already
        if (message.isNotRequested) return;
        if (message.code != ticket.code) return;
        // TBD: refactor to satisfy linter
        // ignore: parameter_assignments
        message = message.copyWith(payload: ticket.payload);

      case MessageCode.setShard:
        if (message.payload == null) return;
        // request already processed
        if (ticket != null) return;
        final vault = _vaultRepository.get(message.vaultId.asKey);
        // vault does not exists
        if (vault == null) return;
        // not owner
        if (vault.ownerId != message.peerId) return;
        // already have this Secret
        if (vault.secrets.containsKey(message.secretShard.id)) return;

      case MessageCode.getShard:
        if (message.payload == null) return;
        // request already processed
        if (ticket != null) return;
        final vault = _vaultRepository.get(message.vaultId.asKey);
        // vault does not exists
        if (vault == null) return;
        // not owner
        if (vault.ownerId != message.peerId) return;
        // Have no such Secret
        if (!vault.secrets.containsKey(message.secretShard.id)) return;
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
