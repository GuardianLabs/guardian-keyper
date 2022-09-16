import 'package:flutter_test/flutter_test.dart';
import 'package:guardian_keyper/src/core/model/core_model.dart';

import '../data/filled_models.dart';

void main() {
  group('Token model', () {
    test(
        'PeerId generation '
        'should be: A equal AA and not equal B', () {
      expect(peerIdA == peerIdAA, true);
      expect(peerIdA == peerIdB, false);
    });
    test(
        'PeerId.empty '
        'should be empty',
        () => expect(emptyPeerId.length == 0, true));
    test(
        'GroupId '
        'should be: A equal AA and not equal B', () {
      expect(groupIdA == groupIdAA, true);
      expect(groupIdA == groupIdB, false);
    });
    test(
        'GroupId,empty '
        'should be empty',
        () => expect(emptyGroupId.length == 0, true));
    test(
        'SecretId '
        'should be: A equal AA and not equal B', () {
      expect(secretIdA == secretIdAA, true);
      expect(secretIdA == secretIdB, false);
    });
    test(
        'SecretId.empty '
        'should be empty',
        () => expect(emptySecretId.length == 0, true));
    test(
        'Nonce '
        'should be: A equal AA and not equal B', () {
      expect(requestIdA == requestIdAA, true);
      expect(requestIdA == requestIdB, false);
    });
    test(
        'Nonce.empty '
        'should be empty',
        () => expect(emptyRequestId.length == 0, true));
  });

  group('QRCode model', () {
    test(
      'QR generation: should not be equal',
      () => expect(qrCode1 == qrCode2, false),
    );

    test(
      'fromBytes/toBytes 1, should be true',
      () => expect(QRCode.fromBytes(qrCode1.toBytes()) == qrCode1, true),
    );
    test(
      'fromBytes/toBytes 2, should be true',
      () => expect(QRCode.fromBytes(qrCode2.toBytes()) == qrCode2, true),
    );
    test(
      'fromBytes/toBytes 3, should be false',
      () => expect(QRCode.fromBytes(qrCode2.toBytes()) == qrCode1, false),
    );
  });

  group('SecretShardModel model', () {
    test('Shard generation: should not be equal', () {
      expect(secretShardA == secretShardB, false);
    });
    test(
      'toBytes/fromBytes 1, should be equal',
      () => expect(
          SecretShardModel.fromBytes(secretShardA.toBytes()), secretShardA),
    );
    test(
      'toBytes/fromBytes 2, should be equal',
      () => expect(
          SecretShardModel.fromBytes(secretShardB.toBytes()), secretShardB),
    );
    test(
      'toBytes/fromBytes 3, should be false',
      () => expect(
          SecretShardModel.fromBytes(secretShardB.toBytes()) == secretShardA,
          false),
    );
    test('toString', () => expect(secretShardA.toString(), 'to Bob of Alice'));
  });

  group('Message model', () {
    test(
      'toBytes/fromBytes 1, should be equal',
      () => expect(
          MessageModel.fromBytes(p2pPacketA.toBytes(), peerIdA), p2pPacketA),
    );
    test(
      'toBytes/fromBytes 2, should be equal',
      () => expect(
          MessageModel.fromBytes(p2pPacketB.toBytes(), peerIdB), p2pPacketB),
    );
    test(
      'toBytes/fromBytes 3, should be false',
      () => expect(
          MessageModel.fromBytes(p2pPacketA.toBytes(), peerIdA) == p2pPacketB,
          false),
    );
    test(
        'process with same peerId',
        () => expect(
            p2pPacketA.process(peerIdA) ==
                p2pPacketA.copyWith(status: MessageStatus.processed),
            true));
    test(
        'process changes PeerId',
        () => expect(
            p2pPacketA.process(peerIdB) == p2pPacketAisProcessedByB, true));
    test(
        'process changes ownerName',
        () => expect(
            p2pPacketA.process(peerIdA, 'Carol') ==
                p2pPacketA.copyWith(
                    status: MessageStatus.processed,
                    secretShard: secretShardA.copyWith(ownerName: 'Carol')),
            true));
    test('clearSecret', () {
      expect(p2pPacketA.clearSecret().secretShard.value == '', true);
    });
    test('clearSecret changes only secretShard value', () {
      final clearedSecretp2pPacketA =
          p2pPacketA.copyWith(secretShard: clearedSecretSecretShardA);
      expect(clearedSecretp2pPacketA == p2pPacketA.clearSecret(), true);
    });
  });
  group('Recovery Group model', () {
    test('should not be equal', () {
      expect(recoveryGroupA == recoveryGroupB, false);
    });
    test(
        ' assert: Recovery Group name is empty',
        () => expect(
            () => RecoveryGroupModel(
                  id: groupIdA,
                  name: '',
                ),
            throwsAssertionError));
    test('toBytes/fromBytes 1, should be true', () {
      expect(
          RecoveryGroupModel.fromBytes(recoveryGroupA.toBytes()) ==
              recoveryGroupA,
          true);
    });
    test('toBytes/fromBytes 2, should be true', () {
      expect(
          RecoveryGroupModel.fromBytes(recoveryGroupB.toBytes()) ==
              recoveryGroupB,
          true);
    });
    test('toBytes/fromBytes 3, should be false', () {
      expect(
          RecoveryGroupModel.fromBytes(recoveryGroupA.toBytes()) ==
              recoveryGroupB,
          false);
    });
    test('addGuardian to empty group', () {
      expect(
          emptyRecoveryGroupA.addGuardian(guardianA) == recoveryGroupA, true);
    });
    test('addGuardian to not empty and not full group', () {
      expect(
          recoveryGroupA.addGuardian(guardianB) == recoveryGroupAwithGuardianB,
          true);
    });
    test(
        'addGuardian throw: full group',
        () => expect(() => fullRecoveryGroupA.addGuardian(guardianA),
            throwsA(isA<RecoveryGroupGuardianLimitexhausted>())));
    test(
        'addGuardian throw: that guardian is already in the group',
        () => expect(() => recoveryGroupA.addGuardian(guardianA),
            throwsA(isA<RecoveryGroupGuardianAlreadyExists>())));
    test(
        'completeGroup, should be true',
        () => expect(
            recoveryGroupA.completeGroup() == completedRecoveryGroupA, true));
    test(
        'GuardianModel '
        'create guardians: should not be equal', () {
      expect(guardianA == guardianB, false);
    });
    test(
        'GuardianModel '
        'assert: name is empty',
        () => expect(
            () => GuardianModel(
                  peerId: peerIdB,
                  name: '',
                ),
            throwsAssertionError));
    test(
        'GuardianModel '
        'toBytes/fromBytes 1, should be true',
        () => expect(
            GuardianModel.fromBytes(guardianA.toBytes()) == guardianA, true));
    test(
        'GuardianModel '
        'toBytes/fromBytes 2, should be true',
        () => expect(
            GuardianModel.fromBytes(guardianB.toBytes()) == guardianB, true));
    test(
        'GuardianModel '
        'toBytes/fromBytes 3, should be false',
        () => expect(
            GuardianModel.fromBytes(guardianA.toBytes()) == guardianB, false));
  });

  group('SettingsModel', () {
    test('should not be equal', () {
      expect(settingsA == settingsB, false);
    });
    test(
        'toBytes/fromBytes 1, should be true',
        () => expect(
            SettingsModel.fromBytes(settingsA.toBytes()) == settingsA, true));
    test(
        'toBytes/fromBytes 2, should be true',
        () => expect(
            SettingsModel.fromBytes(settingsB.toBytes()) == settingsB, true));
    test(
        'toBytes/fromBytes 3, should be false',
        () => expect(
            SettingsModel.fromBytes(settingsA.toBytes()) == settingsB, false));
  });
}
