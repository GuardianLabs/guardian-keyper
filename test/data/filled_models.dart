import 'package:guardian_keyper/domain/entity/id_base.dart';
import 'package:guardian_keyper/feature/message/domain/entity/message_id.dart';
import 'package:guardian_keyper/feature/message/domain/entity/message_model.dart';
import 'package:guardian_keyper/domain/entity/peer_id.dart';
import 'package:guardian_keyper/feature/vault/domain/entity/secret_id.dart';
import 'package:guardian_keyper/feature/vault/domain/entity/secret_shard.dart';
import 'package:guardian_keyper/feature/vault/domain/entity/vault.dart';
import 'package:guardian_keyper/feature/vault/domain/entity/vault_id.dart';

final now = DateTime.timestamp();

final tokenA = IdBase.getNewToken(length: 64);
final tokenB = IdBase.getNewToken(length: 64);
final tokenAA = tokenA;

final peerIdA = PeerId(token: IdBase.getNewToken(length: 64), name: 'Alice');
final peerIdB = PeerId(token: IdBase.getNewToken(length: 64), name: 'Bob');
final peerIdC = PeerId(token: IdBase.getNewToken(length: 64), name: 'Carol');

final vaultIdA = VaultId(name: 'VaultA');
final vaultIdB = VaultId(name: 'VaultB');
final vaultIdC = VaultId(name: 'VaultC');

final requestIdA = MessageId();
final requestIdB = MessageId();

final secretIdA = SecretId(name: 'SecretA');
final secretIdB = SecretId(name: 'SecretB');

final vaultA = Vault(
  id: vaultIdA,
  ownerId: peerIdA,
  guardians: {
    peerIdA: '',
  },
);

final vaultB = Vault(
  id: vaultIdB,
  ownerId: peerIdB,
  guardians: {
    peerIdB: '',
  },
);

final vaultC = Vault(
  id: vaultIdC,
  ownerId: peerIdC,
  guardians: {
    peerIdC: '',
  },
);

final p2pPacketA = MessageModel(
  id: requestIdA,
  peerId: peerIdA,
  timestamp: now,
  code: MessageCode.getShard,
  payload: secretShardA,
);

final p2pPacketB = MessageModel(
  id: requestIdB,
  peerId: peerIdB,
  timestamp: now,
  code: MessageCode.createVault,
  status: MessageStatus.received,
  payload: secretShardB,
);

final secretShardA = SecretShard(
  id: secretIdA,
  shard: 'TopSecretA',
  ownerId: peerIdA,
  vaultId: vaultIdA,
  vaultSize: 3,
  vaultThreshold: 2,
);
final secretShardB = SecretShard(
  id: secretIdB,
  shard: 'TopSecretB',
  ownerId: peerIdB,
  vaultId: vaultIdB,
  vaultSize: 3,
  vaultThreshold: 2,
);
final secretShardC = SecretShard(
  id: SecretId(name: 'SecretC'),
  shard: 'TopSecretC',
  ownerId: peerIdC,
  vaultId: vaultIdC,
  vaultSize: 3,
  vaultThreshold: 2,
);

final clearedSecretSecretShardA = secretShardA.copyWith(shard: '');
