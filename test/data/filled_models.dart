// import 'package:guardian_keyper/src/core/model/core_model.dart';
// import 'package:guardian_keyper/src/core/utils/random_utils.dart';

// final now = DateTime.now();

//Token model
// final peerIdA = PeerId(token: getRandomBytes(64), name: 'Alice');
// final peerIdB = PeerId(token: getRandomBytes(64), name: 'Bob');
// final peerIdAA = PeerId(token: peerIdA.token, name: peerIdA.name);

// final groupIdA = GroupId(name: 'GroupA');
// final groupIdB = GroupId(name: 'GroupB');
// final groupIdAA = GroupId(token: groupIdA.token, name: 'GroupAA');

// final requestIdA = MessageId();
// final requestIdB = MessageId();
// final requestIdAA = MessageId(token: requestIdA.token);

// final secretIdA = SecretId(name: 'SecretA');
// final secretIdB = SecretId(name: 'SecretB');
// final secretIdAA = SecretId(token: secretIdA.token, name: 'SecretAA');

//QRCode model
// final qrCode1 = MessageModel(
//   peerId: peerIdA,
//   code: MessageCode.createGroup,
// );
// final qrCode2 = MessageModel(
//   peerId: peerIdB,
//   code: MessageCode.createGroup,
// );

//Secret shard model
// final secretShardA = SecretShardModel(
//   id: secretIdA,
//   shard: 'TopSecret',
//   ownerId: peerIdA,
//   groupId: groupIdA,
//   groupSize: 3,
//   groupThreshold: 2,
// );
// final secretShardB = SecretShardModel(
//   id: secretIdB,
//   shard: 'TopSecret',
//   ownerId: peerIdB,
//   groupId: groupIdB,
//   groupSize: 3,
//   groupThreshold: 2,
// );
// final clearedSecretSecretShardA = secretShardA.copyWith(shard: '');

//Message model
// final p2pPacketA = MessageModel(
//   id: requestIdA,
//   peerId: peerIdA,
//   timestamp: now,
//   code: MessageCode.getShard,
//   status: MessageStatus.accepted,
//   payload: secretShardA,
// );
// final p2pPacketB = MessageModel(
//   id: requestIdB,
//   peerId: peerIdB,
//   timestamp: now,
//   code: MessageCode.createGroup,
//   status: MessageStatus.rejected,
//   payload: secretShardB,
// );

//Recovery Group model
// final guardianA = GuardianModel(
//   id: peerIdA,
//   name: 'iPhone',
//   tag: 'Piece of ...',
// );

// final guardianB = GuardianModel(
//   id: peerIdB,
//   name: 'SuperPhone',
//   tag: 'My treasure',
// );

// const recoveryGroupAName = 'Recovery Group A';
// final recoveryGroupA = RecoveryGroupModel(
//   id: groupIdA,
//   name: recoveryGroupAName,
//   guardians: {guardianA.id: guardianA},
// );

// final emptyRecoveryGroupA = RecoveryGroupModel(
//   id: groupIdA,
//   name: recoveryGroupAName,
//   // ignore: prefer_const_literals_to_create_immutables
//   guardians: {},
// );

// final recoveryGroupAwithGuardianB = RecoveryGroupModel(
//   id: groupIdA,
//   name: recoveryGroupAName,
//   guardians: {guardianA.id: guardianA, guardianB.id: guardianB},
// );

// final fullRecoveryGroupA = RecoveryGroupModel(
//   id: groupIdA,
//   name: recoveryGroupAName,
//   guardians: {guardianA.id: guardianA, guardianB.id: guardianB},
//   maxSize: 2,
// );

// final completedRecoveryGroupA = RecoveryGroupModel(
//   id: groupIdA,
//   name: recoveryGroupAName,
//   guardians: {guardianA.id: guardianA},
// );

// final recoveryGroupB = RecoveryGroupModel(
//   id: groupIdB,
//   name: 'Recovery Group B',
//   guardians: {guardianB.id: guardianB},
// );

//Settings Model
// const settingsA = SettingsModel(
//   deviceName: 'device A',
//   passCode: '123',
//   isBiometricsEnabled: true,
//   isBootstrapEnabled: false,
// );

// const settingsB = SettingsModel(
//   deviceName: 'device B',
//   passCode: '456',
//   isBiometricsEnabled: false,
//   isBootstrapEnabled: true,
// );
