import 'package:get_it/get_it.dart';

import 'package:guardian_keyper/data/network_manager.dart';
import 'package:guardian_keyper/domain/entity/vault_model.dart';
import 'package:guardian_keyper/domain/entity/message_model.dart';
import 'package:guardian_keyper/domain/entity/secret_shard_model.dart';
import 'package:guardian_keyper/feature/vault/data/vault_repository.dart';
import 'package:guardian_keyper/feature/settings/data/settings_manager.dart';

abstract mixin class MessageEgressMixin {
  Future<void> archivateMessage(MessageModel message);

  Future<void> sendRespone(final MessageModel message) =>
      switch (message.code) {
        MessageCode.createGroup => _sendCreateGroupResponse(message),
        MessageCode.takeGroup => _sendTakeGroupResponse(message),
        MessageCode.getShard => _sendGetShardResponse(message),
        MessageCode.setShard => _sendSetShardResponse(message),
      };

  // Private
  final _networkManager = GetIt.I<NetworkManager>();
  final _settingsManager = GetIt.I<SettingsManager>();
  final _vaultRepository = GetIt.I<VaultRepository>();

  Future<void> _sendCreateGroupResponse(MessageModel message) async {
    await _sendResponse(message);
    if (message.isAccepted) {
      final vault = VaultModel(
        id: message.vault.id,
        ownerId: message.peerId,
        maxSize: message.vault.maxSize,
        threshold: message.vault.threshold,
      );
      await _vaultRepository.put(vault.aKey, vault);
    }
    await archivateMessage(message);
  }

  Future<void> _sendTakeGroupResponse(MessageModel message) async {
    if (message.isAccepted) {
      final vault = _vaultRepository
          .get(message.vault.aKey)!
          .copyWith(ownerId: message.peerId);
      await _sendResponse(message.copyWith(
        payload: vault.copyWith(
          secrets: {for (final secretId in vault.secrets.keys) secretId: ''},
        ),
      ));
      await _vaultRepository.put(vault.aKey, vault);
    } else {
      await _sendResponse(message.copyWith(emptyPayload: true));
    }
    await archivateMessage(message);
  }

  Future<void> _sendSetShardResponse(MessageModel message) async {
    if (message.isAccepted) {
      final vault = _vaultRepository.get(message.vaultId.asKey)!;
      await _vaultRepository.put(
        message.vaultId.asKey,
        vault.copyWith(secrets: {
          ...vault.secrets,
          message.secretShard.id: message.secretShard.shard,
        }),
      );
    }
    await _sendResponse(message.copyWith(emptyPayload: true));
    await archivateMessage(message.copyWith(
      payload: message.secretShard.copyWith(shard: ''),
    ));
  }

  Future<void> _sendGetShardResponse(MessageModel message) async {
    if (message.isAccepted) {
      final vault = _vaultRepository.get(message.vaultId.asKey)!;
      await _sendResponse(
        message.copyWith(
            payload: SecretShardModel(
          id: message.secretShard.id,
          ownerId: vault.ownerId,
          vaultId: vault.id,
          groupSize: vault.maxSize,
          groupThreshold: vault.threshold,
          shard: vault.secrets[message.secretShard.id]!,
        )),
      );
    } else {
      await _sendResponse(message.copyWith(emptyPayload: true));
    }
    await archivateMessage(message);
  }

  Future<void> _sendResponse(MessageModel message) => _networkManager.sendTo(
        message.peerId,
        isConfirmable: true,
        message: message.copyWith(peerId: _settingsManager.selfId),
      );
}
