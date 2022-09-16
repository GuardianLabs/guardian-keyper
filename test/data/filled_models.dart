import 'dart:io' show InternetAddress;
import 'package:guardian_keyper/src/core/model/core_model.dart';
import 'package:guardian_keyper/src/core/utils/random_utils.dart';

//Token model
final peerIdA = PeerId(value: getRandomBytes(64));
final peerIdB = PeerId(value: getRandomBytes(64));
final peerIdAA = PeerId(value: peerIdA.value);
final emptyPeerId = PeerId.empty();

final groupIdA = GroupId.aNew();
final groupIdB = GroupId.aNew();
final groupIdAA = GroupId(value: groupIdA.value);
final emptyGroupId = GroupId.empty();

final requestIdA = Nonce.aNew();
final requestIdB = Nonce.aNew();
final requestIdAA = Nonce(value: requestIdA.value);
final emptyRequestId = Nonce.empty();

final secretIdA = SecretId.aNew();
final secretIdB = SecretId.aNew();
final secretIdAA = SecretId(value: secretIdA.value);
final emptySecretId = SecretId.empty();

//QRCode model
final qrCode1 = QRCode(
  nonce: Nonce.aNew(),
  peerId: peerIdA,
  type: OperationType.authPeer,
  peerName: 'Tester qrCodeA',
  addresses: const [],
);
final qrCode2 = QRCode(
  nonce: Nonce.aNew(),
  peerId: peerIdB,
  type: OperationType.authPeer,
  peerName: 'Tester qrCodeB',
  addresses: [InternetAddress.anyIPv4, InternetAddress.loopbackIPv4],
);

//Secret shard model
final secretShardA = SecretShardModel(
  value: 'TopSecret',
  ownerId: peerIdA,
  ownerName: 'Alice',
  groupId: groupIdA,
  groupName: 'to Bob',
  groupSize: 3,
  groupThreshold: 2,
);
final secretShardB = SecretShardModel(
  value: 'TopSecret',
  ownerId: peerIdB,
  ownerName: 'Bob',
  groupId: groupIdB,
  groupName: 'to Alice',
  groupSize: 3,
  groupThreshold: 2,
);
final clearedSecretSecretShardA = secretShardA.copyWith(value: '');

//Message model
final p2pPacketA = MessageModel(
  peerId: peerIdA,
  type: OperationType.getShard,
  status: MessageStatus.accepted,
  secretShard: secretShardA,
);
final p2pPacketB = MessageModel(
  peerId: peerIdB,
  type: OperationType.authPeer,
  status: MessageStatus.rejected,
  secretShard: secretShardB,
);

final p2pPacketAisProcessedByB = MessageModel(
  peerId: peerIdB,
  type: OperationType.getShard,
  status: MessageStatus.processed,
  secretShard: secretShardA.copyWith(ownerId: peerIdB),
);

//Recovery Group model
final guardianA = GuardianModel(
  peerId: peerIdA,
  name: 'iPhone',
  tag: 'Piece of ...',
);

final guardianB = GuardianModel(
  peerId: peerIdB,
  name: 'SuperPhone',
  tag: 'My treasure',
);

const recoveryGroupAName = 'Recovery Group A';
final recoveryGroupA = RecoveryGroupModel(
  id: groupIdA,
  name: recoveryGroupAName,
  guardians: {guardianA.peerId: guardianA},
);

final emptyRecoveryGroupA = RecoveryGroupModel(
  id: groupIdA,
  name: recoveryGroupAName,
  // ignore: prefer_const_literals_to_create_immutables
  guardians: {},
);

final recoveryGroupAwithGuardianB = RecoveryGroupModel(
  id: groupIdA,
  name: recoveryGroupAName,
  guardians: {guardianA.peerId: guardianA, guardianB.peerId: guardianB},
);

final fullRecoveryGroupA = RecoveryGroupModel(
  id: groupIdA,
  name: recoveryGroupAName,
  guardians: {guardianA.peerId: guardianA, guardianB.peerId: guardianB},
  maxSize: 2,
);

final completedRecoveryGroupA = RecoveryGroupModel(
  id: groupIdA,
  name: recoveryGroupAName,
  guardians: {guardianA.peerId: guardianA},
  hasSecret: true,
);

final recoveryGroupB = RecoveryGroupModel(
  id: groupIdB,
  name: 'Recovery Group B',
  guardians: {guardianB.peerId: guardianB},
);

//Settings Model
const settingsA = SettingsModel(
  deviceName: 'device A',
  passCode: '123',
  isBiometricsEnabled: true,
  isProxyEnabled: false,
);

const settingsB = SettingsModel(
  deviceName: 'device B',
  passCode: '456',
  isBiometricsEnabled: false,
  isProxyEnabled: true,
);
