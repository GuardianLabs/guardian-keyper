import 'package:get_it/get_it.dart';

import 'package:guardian_keyper/feature/vault/domain/entity/vault.dart';
import 'package:guardian_keyper/feature/vault/domain/entity/vault_id.dart';
import 'package:guardian_keyper/feature/network/domain/entity/peer_id.dart';
import 'package:guardian_keyper/feature/message/domain/entity/message_model.dart';
import 'package:guardian_keyper/feature/message/data/message_repository.dart';
import 'package:guardian_keyper/feature/network/data/network_manager.dart';

import 'message_ingress_mixin.dart';
import 'message_egress_mixin.dart';

/// Depends on:
/// [PreferencesService, MessageRepository, VaultRepository, NetworkManager]
class MessageInteractor with MessageIngressMixin, MessageEgressMixin {
  MessageInteractor() {
    _networkManager.messageStream.listen(onMessage);
  }

  final _networkManager = GetIt.I<NetworkManager>();
  final _messageRepository = GetIt.I<MessageRepository>();

  PeerId get selfId => _networkManager.selfId;

  Iterable<MessageModel> get messages => _messageRepository.values;

  @override
  Future<void> archivateMessage(MessageModel message) async {
    await _messageRepository.delete(message.aKey);
    await _messageRepository.put(
      message.timestamp.millisecondsSinceEpoch.toString(),
      message,
    );
  }

  Future<void> flush() => _messageRepository.flush();

  Future<void> pruneMessages() => _messageRepository.prune();

  Future<bool> pingPeer(PeerId peerId) => _networkManager.pingPeer(peerId);

  bool getPeerStatus(PeerId peerId) => _networkManager.getPeerStatus(peerId);

  Stream<MessageRepositoryEvent> watch([String? key]) =>
      _messageRepository.watch(key);

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
