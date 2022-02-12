import 'recovery_group_model.dart';

const _group1 = {
  'Melly Caramelly': RecoveryGroupGuardianModel(
    name: 'Melly Caramelly',
    code: '01234567890ABCDEF',
    tag: 'Wife`s iPhone',
    status: RecoveryGroupGuardianStatus.missed,
  ),
};

const _group2 = {
  ..._group1,
  'My iPad': RecoveryGroupGuardianModel(
    name: 'My iPad',
    code: '01234567890ABCDEF',
    status: RecoveryGroupGuardianStatus.notConnected,
  ),
};

const _group3 = {
  ..._group2,
  'My MacBook Pro': RecoveryGroupGuardianModel(
    name: 'My MacBook Pro',
    code: '01234567890ABCDEF',
    status: RecoveryGroupGuardianStatus.connected,
  ),
};

Map<String, RecoveryGroupModel> _groups = {
  'MetaMask Wallet': const RecoveryGroupModel(
    name: 'MetaMask Wallet',
    type: RecoveryGroupType.devices,
    guardians: _group1,
  ),
  'Binance Pass': const RecoveryGroupModel(
    name: 'Binance Pass',
    type: RecoveryGroupType.devices,
    guardians: _group2,
  ),
  'Phantom wallet': const RecoveryGroupModel(
    name: 'Phantom wallet',
    type: RecoveryGroupType.devices,
    guardians: _group3,
    secrets: {
      'SecretName': RecoveryGroupSecretModel(
        name: 'SecretName',
        secret: 'My very secret secret',
      ),
    },
  ),
};

class RecoveryGroupService {
  Future<Map<String, RecoveryGroupModel>> getGroups() async {
    return _groups;
  }
}
