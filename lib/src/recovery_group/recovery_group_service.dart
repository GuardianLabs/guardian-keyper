import 'recovery_group_model.dart';

final _group1 = {
  '1': const RecoveryGroupGuardianModel(name: '1', code: '', tag: ''),
};

final _group2 = {
  ..._group1,
  '2': const RecoveryGroupGuardianModel(name: '2', code: '', tag: ''),
};

final _group3 = {
  ..._group2,
  '3': const RecoveryGroupGuardianModel(name: '3', code: '', tag: ''),
};

final _groups = <String, RecoveryGroupModel>{
  'Fake group 1': RecoveryGroupModel(
    name: 'Fake group 1',
    type: RecoveryGroupType.devices,
    guardians: _group1,
  ),
  'Fake group 2': RecoveryGroupModel(
    name: 'Fake group 2',
    type: RecoveryGroupType.devices,
    guardians: _group2,
  ),
  'Fake group 3': RecoveryGroupModel(
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
