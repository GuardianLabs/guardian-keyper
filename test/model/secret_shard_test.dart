import 'package:flutter_test/flutter_test.dart';
import 'package:guardian_keyper/feature/vault/domain/entity/secret_shard.dart';
import '../data/filled_models.dart';

void main() {
  group('==', () {
    final ss = SecretShard(
      id: secretIdA,
      shard: 'TopSecret',
      ownerId: peerIdA,
      vaultId: vaultIdA,
      vaultSize: 3,
      vaultThreshold: 2,
    );

    final ssTheSameId = SecretShard(
      id: secretIdA,
      shard: 'TopSecret1',
      ownerId: peerIdB,
      vaultId: vaultIdB,
      vaultSize: 5,
      vaultThreshold: 4,
    );

    final ssTheSameExceptId = SecretShard(
      id: secretIdB,
      shard: 'TopSecret',
      ownerId: peerIdA,
      vaultId: vaultIdA,
      vaultSize: 3,
      vaultThreshold: 2,
    );

    test(
      'everything is different except id, should be true',
      () => expect(
        ss == ssTheSameId,
        true,
      ),
    );
    test(
      'everything is equal except id, should be false',
      () => expect(
        ss == ssTheSameExceptId,
        false,
      ),
    );
  });

    group(
    'hashCode',
    () {
      final s = {secretShardA, secretShardB};

      test(
          'should be true',
          () => expect(
                s.containsAll({secretShardA, secretShardB}),
                true,
              ));
      test(
          'should be false',
          () => expect(
                s.containsAll({secretShardA, secretShardB, secretShardC}),
                false,
              ));
    },
  );

  test(
    'Shard generation: should not be equal',
    () => expect(secretShardA == secretShardB, false),
  );

  group('toBytes/fromBytes', () {
    test(
      'toBytes/fromBytes 1, should be equal',
      () => expect(
        SecretShard.fromBytes(secretShardA.toBytes()) == secretShardA,
        true,
      ),
    );
    test(
      'toBytes/fromBytes 2, should be false',
      () => expect(
        SecretShard.fromBytes(secretShardB.toBytes()) == secretShardA,
        false,
      ),
    );
    test('toString', () => expect(secretShardA.toString(), 'VaultA of Alice'));
  });
}
