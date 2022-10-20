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
        'GroupId '
        'should be: A equal AA and not equal B', () {
      expect(groupIdA == groupIdAA, true);
      expect(groupIdA == groupIdB, false);
    });
    test(
        'SecretId '
        'should be: A equal AA and not equal B', () {
      expect(secretIdA == secretIdAA, true);
      expect(secretIdA == secretIdB, false);
    });
    test(
        'Nonce '
        'should be: A equal AA and not equal B', () {
      expect(requestIdA == requestIdAA, true);
      expect(requestIdA == requestIdB, false);
    });
  });

  group('QRCode model', () {
    test(
      'QR generation: should not be equal',
      () => expect(qrCode1 == qrCode2, false),
    );

    test(
      'fromBytes/toBytes 1, should be true',
      () => expect(MessageModel.fromBytes(qrCode1.toBytes()) == qrCode1, true),
    );
    test(
      'fromBytes/toBytes 2, should be true',
      () => expect(MessageModel.fromBytes(qrCode2.toBytes()) == qrCode2, true),
    );
    test(
      'fromBytes/toBytes 3, should be false',
      () => expect(MessageModel.fromBytes(qrCode2.toBytes()) == qrCode1, false),
    );
  });

  group('SecretShardModel model', () {
    test(
      'Shard generation: should not be equal',
      () => expect(secretShardA == secretShardB, false),
    );
    test(
      'toBytes/fromBytes 1, should be equal',
      () => expect(
        SecretShardModel.fromBytes(secretShardA.toBytes()) == secretShardA,
        true,
      ),
    );
    test(
      'toBytes/fromBytes 2, should be false',
      () => expect(
        SecretShardModel.fromBytes(secretShardB.toBytes()) == secretShardA,
        false,
      ),
    );
    test('toString', () => expect(secretShardA.toString(), 'to Bob of Alice'));
  });

  group('Message model', () {
    test(
      'toBytes/fromBytes 1, should be equal',
      () => expect(MessageModel.fromBytes(p2pPacketA.toBytes()), p2pPacketA),
    );
    test(
      'toBytes/fromBytes 2, should be equal',
      () => expect(MessageModel.fromBytes(p2pPacketB.toBytes()), p2pPacketB),
    );
    test(
      'toBytes/fromBytes 3, should be false',
      () => expect(
        MessageModel.fromBytes(p2pPacketA.toBytes()) == p2pPacketB,
        false,
      ),
    );
  });

  // group('Recovery Group model', () {
  //   test(
  //     'should not be equal',
  //     () => expect(recoveryGroupA == recoveryGroupB, false),
  //   );
  //   test('toBytes/fromBytes 1, should be true', () {
  //     expect(
  //       RecoveryGroupModel.fromBytes(recoveryGroupA.toBytes()),
  //       recoveryGroupA,
  //     );
  //   });
  //   test(
  //     'toBytes/fromBytes 2, should be true',
  //     () => expect(
  //       RecoveryGroupModel.fromBytes(recoveryGroupB.toBytes()),
  //       recoveryGroupB,
  //     ),
  //   );
  //   test('toBytes/fromBytes 3, should be false', () {
  //     expect(
  //         RecoveryGroupModel.fromBytes(recoveryGroupA.toBytes()) ==
  //             recoveryGroupB,
  //         false);
  //   });
  //   test('addGuardian to empty group', () {
  //     expect(
  //         emptyRecoveryGroupA.addGuardian(guardianA) == recoveryGroupA, true);
  //   });
  //   test('addGuardian to not empty and not full group', () {
  //     expect(
  //         recoveryGroupA.addGuardian(guardianB) == recoveryGroupAwithGuardianB,
  //         true);
  //   });
  //   test(
  //       'addGuardian throw: full group',
  //       () => expect(() => fullRecoveryGroupA.addGuardian(guardianA),
  //           throwsA(isA<RecoveryGroupGuardianLimitExhausted>())));
  //   test(
  //       'addGuardian throw: that guardian is already in the group',
  //       () => expect(() => recoveryGroupA.addGuardian(guardianA),
  //           throwsA(isA<RecoveryGroupGuardianAlreadyExists>())));
  //   test(
  //       'GuardianModel '
  //       'create guardians: should not be equal', () {
  //     expect(guardianA == guardianB, false);
  //   });
  //   test(
  //       'GuardianModel '
  //       'toBytes/fromBytes 1, should be true',
  //       () => expect(
  //           GuardianModel.fromBytes(guardianA.toBytes()) == guardianA, true));
  //   test(
  //       'GuardianModel '
  //       'toBytes/fromBytes 2, should be true',
  //       () => expect(
  //           GuardianModel.fromBytes(guardianB.toBytes()) == guardianB, true));
  //   test(
  //       'GuardianModel '
  //       'toBytes/fromBytes 3, should be false',
  //       () => expect(
  //           GuardianModel.fromBytes(guardianA.toBytes()) == guardianB, false));
  // });

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
