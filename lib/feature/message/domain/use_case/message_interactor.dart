import 'package:get_it/get_it.dart';

import 'package:guardian_keyper/feature/network/data/network_manager.dart';
import 'package:guardian_keyper/feature/network/domain/entity/peer_id.dart';
import 'package:guardian_keyper/feature/vault/domain/entity/vault.dart';
import 'package:guardian_keyper/feature/vault/domain/entity/vault_id.dart';

import '../../data/message_repository.dart';
import '../entity/message_model.dart';
import 'message_ingress_mixin.dart';
import 'message_egress_mixin.dart';

/// Depends on:
/// [PreferencesService, MessageRepository, VaultRepository, NetworkManager]
class MessageInteractor with MessageIngressMixin, MessageEgressMixin {
  MessageInteractor() {
    _networkManager.messageStream.listen(onMessage);
  }

  late final flush = _messageRepository.flush;
  late final watch = _messageRepository.watch;
  late final pruneMessages = _messageRepository.prune;
  late final getPeerStatus = _networkManager.getPeerStatus;
  late final pingPeer = _networkManager.pingPeer;

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

  /// Create ticket to join vault
  Future<MessageModel> createJoinVaultCode() async {
    final message = MessageModel(
      code: MessageCode.createGroup,
      peerId: _networkManager.selfId,
    );
    await _messageRepository.put(message.aKey, message);
    return message;
  }

  /// Create ticket to take vault
  Future<MessageModel> createTakeVaultCode(VaultId? groupId) async {
    final message = MessageModel(
      code: MessageCode.takeGroup,
      peerId: _networkManager.selfId,
    );
    await _messageRepository.put(
      message.aKey,
      message.copyWith(
        payload: Vault(id: groupId, ownerId: PeerId.empty),
      ),
    );
    return message;
  }
}
