import '/src/core/di_container.dart';
import '/src/core/model/core_model.dart';

Future<void> migrateStorage({
  required PeerId myPeerId,
  required Box<MessageModel> boxMessages,
  required Box<SecretShardModel> boxSecretShards,
  required Box<RecoveryGroupModel> boxRecoveryGroups,
}) async {
  // migrate groups from old format
  if (boxSecretShards.isNotEmpty) {
    await boxRecoveryGroups.putAll({
      for (final shard in boxSecretShards.values)
        shard.groupId.asKey: RecoveryGroupModel(
          id: shard.groupId,
          ownerId: shard.ownerId,
          maxSize: shard.groupSize,
          threshold: shard.groupThreshold,
          secrets: {shard.id: shard.shard},
        ),
    });
    await boxSecretShards.clear();
    await boxSecretShards.flush();
    await boxSecretShards.close();
  }
}
