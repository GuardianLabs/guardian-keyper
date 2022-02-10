// import 'package:flutter/material.dart';

enum RecoveryGroupStatus { completed, notCompleted, missed }
enum RecoveryGroupType { none, devices, fiduciaries }

class RecoveryGroupModel {
  String name;
  String description;
  RecoveryGroupType type;
  final int size;
  final int threshold;
  Map<String, RecoveryGroupGuardianModel> guardians = {};
  String secret = '';

  RecoveryGroupModel({
    required this.name,
    this.description = '',
    this.size = 3,
    this.threshold = 2,
    this.type = RecoveryGroupType.none,
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

class RecoveryGroupGuardianModel {
  RecoveryGroupGuardianModel({
    this.name = '',
    this.code = '',
    this.tag = '',
  });

  String name;
  String code;
  String tag;
}
