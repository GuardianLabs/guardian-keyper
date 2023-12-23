import 'package:guardian_keyper/feature/network/data/network_manager.dart';
import 'package:guardian_keyper/feature/message/domain/entity/message_model.dart';
import 'package:guardian_keyper/feature/vault/domain/entity/secret_shard.dart';
import 'package:guardian_keyper/feature/vault/data/vault_repository.dart';

abstract mixin class MessageEgressMixin {
  final _networkManager = GetIt.I<NetworkManager>();
  final _vaultRepository = GetIt.I<VaultRepository>();

  Future<void> archivateMessage(MessageModel message);

  Future<void> sendRespone(MessageModel message) => switch (message.code) {
        MessageCode.createVault => _sendCreateVaultResponse(message),
        MessageCode.takeVault => _sendTakeVaultResponse(message),
        MessageCode.getShard => _sendGetShardResponse(message),
        MessageCode.setShard => _sendSetShardResponse(message),
      };

  Future<void> _sendCreateVaultResponse(MessageModel message) async {
    await _sendResponse(message);
    if (message.isAccepted) {
      final vault = Vault(
        id: message.vault.id,
        ownerId: message.peerId,
        maxSize: message.vault.maxSize,
        threshold: message.vault.threshold,
      );
      await _vaultRepository.put(vault.aKey, vault);
    }
    await archivateMessage(message);
  }

  Future<void> _sendTakeVaultResponse(MessageModel message) async {
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
            payload: SecretShard(
          id: message.secretShard.id,
          ownerId: vault.ownerId,
          vaultId: vault.id,
          vaultSize: vault.maxSize,
          vaultThreshold: vault.threshold,
          shard: vault.secrets[message.secretShard.id]!,
        )),
      );
    } else {
      await _sendResponse(message.copyWith(emptyPayload: true));
    }
    await archivateMessage(message);
  }

  Future<void> _sendResponse(MessageModel message) =>
      _networkManager.sendToPeer(
        message.peerId,
        isConfirmable: true,
        message: message.copyWith(peerId: _networkManager.selfId),
      );
}
