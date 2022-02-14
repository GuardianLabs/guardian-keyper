import 'package:flutter/material.dart';

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
    if (guardian.code.isEmpty) {
      throw RecoveryGroupGuardianCodeIsEmpty();
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
    if (secret.token.isEmpty) {
      throw RecoveryGroupSecretIsEmpty();
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

  bool get isCompleted => guardians.length == size;
  bool get isMissed => guardians.length < threshold;
  bool get isNotCompleted => !isCompleted && !isMissed;
}

class RecoveryGroupGuardianAlreadyExists implements Exception {
  static const description =
      'Guardian with given name already exists in that group!';
}

class RecoveryGroupGuardianLimitexhausted implements Exception {
  static const description = 'Guardian group size limit exhausted!';
}

class RecoveryGroupGuardianCodeIsEmpty implements Exception {
  static const description = 'Guardian code could not be empty!';
}

class RecoveryGroupSecretAlreadyExists implements Exception {
  static const description =
      'Secret with given name already exists in that group!';
}

class RecoveryGroupSecretIsEmpty implements Exception {
  static const description = 'Secret could not be empty!';
}

// RecoveryGroupGuardianModel

@immutable
class RecoveryGroupGuardianModel {
  const RecoveryGroupGuardianModel({
    required this.name,
    this.code = '',
    this.tag = '',
  }) : assert(name != '');

  final String name;
  final String code;
  final String tag;
}

// RecoveryGroupSecretModel

@immutable
class RecoveryGroupSecretModel {
  const RecoveryGroupSecretModel({
    required this.name,
    this.token = '',
  }) : assert(name != '');

  final String name;
  final String token;
}
