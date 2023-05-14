import 'package:get_it/get_it.dart';

import 'package:guardian_keyper/data/network_manager.dart';
import 'package:guardian_keyper/domain/entity/_id/peer_id.dart';
import 'package:guardian_keyper/domain/entity/_id/vault_id.dart';
import 'package:guardian_keyper/domain/entity/vault_model.dart';
import 'package:guardian_keyper/domain/entity/message_model.dart';
import 'package:guardian_keyper/feature/settings/data/settings_manager.dart';

import '../data/message_repository.dart';
import 'message_ingress_mixin.dart';
import 'message_egress_maxin.dart';

typedef MessageEvent = ({String key, MessageModel? value, bool isDeleted});

class MessageInteractor with MessageIngressMixin, MessageEgressMixin {
  MessageInteractor() {
    _networkManager.messageStream.listen(onMessage);
  }

  late final messageTTL = _networkManager.messageTTL;

  late final flush = _messageRepository.flush;
  late final pingPeer = _networkManager.pingPeer;
  late final getPeerStatus = _networkManager.getPeerStatus;

  PeerId get selfId => _settingsManager.selfId;

  Iterable<MessageModel> get messages => _messageRepository.values;

  @override
  Future<void> archivateMessage(final MessageModel message) async {
    await _messageRepository.delete(message.aKey);
    await _messageRepository.put(
      message.timestamp.millisecondsSinceEpoch.toString(),
      message,
    );
  }

  Stream<MessageEvent> watch() =>
      _messageRepository.watch().map<MessageEvent>((e) => (
            key: e.key as String,
            value: e.value as MessageModel?,
            isDeleted: e.deleted,
          ));

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

  Future<void> pruneMessages() async {
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

  // Private
  final _networkManager = GetIt.I<NetworkManager>();
  final _settingsManager = GetIt.I<SettingsManager>();
  final _messageRepository = GetIt.I<MessageRepository>();
}
