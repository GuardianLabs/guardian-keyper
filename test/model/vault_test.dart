import 'package:flutter_test/flutter_test.dart';
import 'package:guardian_keyper/feature/vault/domain/entity/vault.dart';
import '../data/filled_models.dart';

void main() {
  group('==', () {
    final v = Vault(
      id: vaultIdA,
      ownerId: peerIdA,
      guardians: {
        peerIdA: '',
      },
    );

    final vTheSameId = Vault(
      id: vaultIdA,
      ownerId: peerIdB,
      guardians: {
        peerIdB: '',
      },
    );

    final vTheSameExceptId = Vault(
      id: vaultIdB,
      ownerId: peerIdA,
      guardians: {
        peerIdA: '',
      },
    );

    test(
      'everything is different except id, should be true',
      () => expect(
        v == vTheSameId,
        true,
      ),
    );
    test(
      'everything is equal except id, should be false',
      () => expect(
        v == vTheSameExceptId,
        false,
      ),
    );
  });

  group(
    'hashCode',
    () {
      final s = {vaultA, vaultB};

      test(
          'should be true',
          () => expect(
                s.containsAll({vaultA, vaultB}),
                true,
              ));
      test(
          'should be false',
          () => expect(
                s.containsAll({vaultA, vaultB, vaultC}),
                false,
              ));
    },
  );

  test(
    'Vault generation: should not be equal',
    () => () => expect(
          vaultA == vaultB,
          false,
        ),
  );

  group('toBytes/fromBytes', () {
    test(
      'toBytes/fromBytes 1, should be true',
      () => expect(
        Vault.fromBytes(vaultA.toBytes()),
        vaultA,
      ),
    );
    test(
      'toBytes/fromBytes 2, should be true',
      () => expect(
        Vault.fromBytes(vaultB.toBytes()),
        vaultB,
      ),
    );
    test(
      'toBytes/fromBytes 3, should be false',
      () => expect(
        Vault.fromBytes(vaultA.toBytes()) == vaultB,
        false,
      ),
    );
  });
}
