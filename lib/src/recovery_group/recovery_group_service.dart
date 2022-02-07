import 'recovery_group_model.dart';

const _group1 = {
  '1': RecoveryGroupMemberModel(name: '1'),
  '2': RecoveryGroupMemberModel(name: '2'),
};

const _group2 = {
  ..._group1,
  '3': RecoveryGroupMemberModel(name: '3'),
};

const _group3 = {
  ..._group2,
  '4': RecoveryGroupMemberModel(name: '4'),
  '5': RecoveryGroupMemberModel(name: '5'),
};

const _groups = <String, RecoveryGroupModel>{
  'Fake group 1': RecoveryGroupModel(
    name: 'Fake group 1',
    description:
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod. ',
    members: _group1,
  ),
  'Fake group 2': RecoveryGroupModel(
    name: 'Fake group 2',
    description:
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod. ',
    members: _group2,
  ),
  'Fake group 3': RecoveryGroupModel(
    name: 'Fake group 3',
    description:
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod. ',
    members: _group3,
  ),
};

class RecoveryGroupService {
  Future<Map<String, RecoveryGroupModel>> getGroups() async {
    return _groups;
  }
}
