import 'package:flutter/foundation.dart';

enum RecoveryGroupStatus { completed, notCompleted, missed }

@immutable
class RecoveryGroupModel {
  final String name;
  final String description;
  final int size;
  final Map<String, RecoveryGroupMemberModel> members;

  const RecoveryGroupModel({
    required this.name,
    required this.description,
    this.size = 5,
    required this.members,
  });

  RecoveryGroupStatus get status {
    if (members.length == size) {
      return RecoveryGroupStatus.completed;
    }
    if (members.isEmpty || members.length < size / 2) {
      return RecoveryGroupStatus.missed;
    }
    return RecoveryGroupStatus.notCompleted;
  }
}

@immutable
class RecoveryGroupMemberModel {
  const RecoveryGroupMemberModel({required this.name});

  final String name;
}
