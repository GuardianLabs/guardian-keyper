import 'package:flutter/material.dart';

enum RecoveryGroupStatus { completed, notCompleted, missed }
enum RecoveryGroupType { devices, fiduciaries }

class RecoveryGroupModel {
  final String name;
  final RecoveryGroupType type;
  final int size;
  final int threshold;
  Map<String, RecoveryGroupGuardianModel> guardians = {};
  String secret = '';

  RecoveryGroupModel({
    required this.name,
    this.size = 3,
    this.threshold = 2,
    required this.type,
    Map<String, RecoveryGroupGuardianModel>? guardians,
  }) {
    if (guardians != null) this.guardians = guardians;
  }

  RecoveryGroupStatus get status {
    if (guardians.length == size) {
      return RecoveryGroupStatus.completed;
    }
    if (guardians.length < threshold) {
      return RecoveryGroupStatus.missed;
    }
    return RecoveryGroupStatus.notCompleted;
  }
}

@immutable
class RecoveryGroupGuardianModel {
  const RecoveryGroupGuardianModel({
    required this.name,
    required this.code,
    required this.tag,
  });

  final String name;
  final String code;
  final String tag;
}
