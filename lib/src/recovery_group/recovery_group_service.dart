import 'recovery_group_model.dart';

final _group1 = {
  '1': RecoveryGroupGuardianModel(name: '1', code: ''),
};

final _group2 = {
  ..._group1,
  '2': RecoveryGroupGuardianModel(name: '2', code: ''),
};

final _group3 = {
  ..._group2,
  '3': RecoveryGroupGuardianModel(name: '3', code: ''),
};

final _groups = <String, RecoveryGroupModel>{
  'Fake group 1': RecoveryGroupModel(
    name: 'Fake group 1',
    description:
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod. ',
    guardians: _group1,
  ),
  'Fake group 2': RecoveryGroupModel(
    name: 'Fake group 2',
    description:
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod. ',
    guardians: _group2,
  ),
  'Fake group 3': RecoveryGroupModel(
    name: 'Fake group 3',
    description:
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod. ',
    guardians: _group3,
  ),
};

class RecoveryGroupService {
  Future<Map<String, RecoveryGroupModel>> getGroups() async {
    return _groups;
  }
}
