import 'package:flutter/material.dart';

enum RecoveryGroupStatus { completed, notCompleted, missed }
enum RecoveryGroupType { devices, fiduciaries }

@immutable
class RecoveryGroupModel {
  final String name;
  final RecoveryGroupType type;
  final int size;
  final int threshold;
  final Map<String, RecoveryGroupGuardianModel> guardians;
  final Map<String, RecoveryGroupSecretModel> secrets;

  const RecoveryGroupModel({
    required this.name,
    required this.type,
    this.size = 3,
    this.threshold = 2,
    this.secrets = const {},
    this.guardians = const {},
  });

  RecoveryGroupModel addGuardian(RecoveryGroupGuardianModel guardian) {
    if (guardians.containsKey(guardian.name)) {
      throw RecoveryGroupGuardianAlreadyExists();
    }
    if (guardians.length == size) {
      throw RecoveryGroupGuardianLimitexhausted();
    }
    return RecoveryGroupModel(
      name: name,
      type: type,
      size: size,
      threshold: threshold,
      secrets: secrets,
      guardians: {...guardians, guardian.name: guardian},
    );
  }

  RecoveryGroupModel addSecret(RecoveryGroupSecretModel secret) {
    if (secrets.containsKey(secret.name)) {
      throw RecoveryGroupSecretAlreadyExists();
    }
    return RecoveryGroupModel(
      name: name,
      type: type,
      size: size,
      threshold: threshold,
      secrets: {...secrets, secret.name: secret},
      guardians: guardians,
    );
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
    this.tag = '',
  })  : assert(name != ''),
        assert(code != '');

  final String name;
  final String code;
  final String tag;
}

@immutable
class RecoveryGroupSecretModel {
  const RecoveryGroupSecretModel({
    required this.name,
    required this.secret,
  })  : assert(name != ''),
        assert(secret != '');

  final String name;
  final String secret;
}

class RecoveryGroupGuardianAlreadyExists implements Exception {
  static const description =
      'Guardian with given name already exists in that group!';
}

class RecoveryGroupGuardianLimitexhausted implements Exception {
  static const description = 'Guardian group size limit exhausted!';
}

class RecoveryGroupSecretAlreadyExists implements Exception {
  static const description =
      'Secret with given name already exists in that group!';
}
