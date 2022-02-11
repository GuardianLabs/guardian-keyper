import 'recovery_group_model.dart';

const _group1 = {
  '1': RecoveryGroupGuardianModel(name: '1', code: '1'),
};

const _group2 = {
  ..._group1,
  '2': RecoveryGroupGuardianModel(name: '2', code: '2'),
};

const _group3 = {
  ..._group2,
  '3': RecoveryGroupGuardianModel(name: '3', code: '3'),
};

Map<String, RecoveryGroupModel> _groups = {
  'Fake group 1': const RecoveryGroupModel(
    name: 'Fake group 1',
    type: RecoveryGroupType.devices,
    guardians: _group1,
  ),
  'Fake group 2': const RecoveryGroupModel(
    name: 'Fake group 2',
    type: RecoveryGroupType.devices,
    guardians: _group2,
  ),
  'Fake group 3': const RecoveryGroupModel(
    name: 'Fake group 3',
    type: RecoveryGroupType.devices,
    guardians: _group3,
  ),
};

class RecoveryGroupService {
  Future<Map<String, RecoveryGroupModel>> getGroups() async {
    return _groups;
  }
}
