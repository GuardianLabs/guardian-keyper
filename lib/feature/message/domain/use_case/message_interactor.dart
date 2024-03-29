import 'dart:async';
import 'package:collection/collection.dart';

import 'package:guardian_keyper/feature/vault/domain/entity/vault.dart';
import 'package:guardian_keyper/feature/vault/domain/entity/vault_id.dart';
import 'package:guardian_keyper/domain/entity/peer_id.dart';
import 'package:guardian_keyper/feature/message/domain/entity/message_model.dart';
import 'package:guardian_keyper/feature/message/data/message_repository.dart';
import 'package:guardian_keyper/data/managers/network_manager.dart';

import 'message_ingress_mixin.dart';
import 'message_egress_mixin.dart';

export 'package:get_it/get_it.dart';

/// Depends on:
/// [settingsRepository, MessageRepository, VaultRepository, NetworkManager]
class MessageInteractor with MessageIngressMixin, MessageEgressMixin {
  MessageInteractor() {
    _streamSubscription = _networkManager.messageStream.listen(onMessage);
  }

  final _networkManager = GetIt.I<NetworkManager>();
  final _messageRepository = GetIt.I<MessageRepository>();

  late final StreamSubscription<MessageModel> _streamSubscription;

  PeerId get selfId => _networkManager.selfId;

  Iterable<MessageModel> get messages => _messageRepository.values;

  List<MessageModel> get requestsSortedByTimestamp => _messageRepository.values
      .where((e) => e.peerId != selfId)
      .sorted((a, b) => b.timestamp.compareTo(a.timestamp));

  Future<void> close() async {
    await _streamSubscription.cancel();
  }

  Future<void> flush() => _messageRepository.flush();

  Future<void> pruneMessages() async {
    await _messageRepository.prune();
    await _messageRepository.flush();
  }

  Stream<MessageRepositoryEvent> watch([String? key]) =>
      _messageRepository.watch(key);

  Future<bool> pingPeer(PeerId peerId) => _networkManager.pingPeer(peerId);

  bool getPeerStatus(PeerId peerId) => _networkManager.getPeerStatus(peerId);

  /// Create ticket to join vault
  Future<MessageModel> createJoinVaultCode() async {
    final message = MessageModel(
      code: MessageCode.createVault,
      peerId: _networkManager.selfId,
    );
    await _messageRepository.put(message.aKey, message);
    return message;
  }

  /// Create ticket to take vault ownership
  Future<MessageModel> createTakeVaultCode(VaultId vaultId) async {
    final message = MessageModel(
      code: MessageCode.takeVault,
      peerId: _networkManager.selfId,
    );
    await _messageRepository.put(
      message.aKey,
      message.copyWith(
        payload: Vault(id: vaultId, ownerId: PeerId.empty),
      ),
    );
    return message;
  }
}
