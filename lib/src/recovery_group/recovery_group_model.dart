import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

import '../core/model/pub_key_model.dart';

enum RecoveryGroupType { devices, fiduciaries }

@immutable
class RecoveryGroupModel {
  final Uint8List id;
  final String name;
  final RecoveryGroupType type;
  final int size;
  final int threshold;
  final Map<String, RecoveryGroupGuardianModel> guardians;
  final Map<String, RecoveryGroupSecretModel> secrets;

  const RecoveryGroupModel({
    required this.id,
    required this.name,
    required this.type,
    this.size = 3,
    this.threshold = 2,
    this.secrets = const {},
    this.guardians = const {},
  }) : assert(name != '');

  factory RecoveryGroupModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> secretsMap = json['secrets'];
    secretsMap.updateAll((key, value) =>
        RecoveryGroupSecretModel.fromJson(value as Map<String, dynamic>));

    Map<String, dynamic> guardiansMap = json['guardians'];
    guardiansMap.updateAll((key, value) =>
        RecoveryGroupGuardianModel.fromJson(value as Map<String, dynamic>));

    return RecoveryGroupModel(
      id: base64Decode(json['id'] as String),
      name: json['name'] as String,
      type: RecoveryGroupType.values.byName(json['type']),
      size: json['size'] as int,
      threshold: json['threshold'] as int,
      secrets: secretsMap.cast<String, RecoveryGroupSecretModel>(),
      guardians: guardiansMap.cast<String, RecoveryGroupGuardianModel>(),
    );
  }

  static Map<String, dynamic> toJson(RecoveryGroupModel value) => {
        'id': base64Encode(value.id),
        'name': value.name,
        'type': value.type.name,
        'size': value.size,
        'threshold': value.threshold,
        'secrets': value.secrets,
        'guardians': value.guardians,
      };

  RecoveryGroupModel addGuardian(RecoveryGroupGuardianModel guardian) {
    if (guardians.containsKey(guardian.name)) {
      throw RecoveryGroupGuardianAlreadyExists();
    }
    if (guardians.length >= size) {
      throw RecoveryGroupGuardianLimitexhausted();
    }
    return RecoveryGroupModel(
      id: id,
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
      id: id,
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

class RecoveryGroupSecretAlreadyExists implements Exception {
  static const description =
      'Secret with given name already exists in that group!';
}

// RecoveryGroupGuardianModel

@immutable
class RecoveryGroupGuardianModel {
  final String name;
  final String tag;
  final PubKey pubKey;
  final PubKey signPubKey;

  const RecoveryGroupGuardianModel({
    required this.name,
    this.tag = '',
    required this.pubKey,
    required this.signPubKey,
  }) : assert(name != '');

  factory RecoveryGroupGuardianModel.fromJson(Map<String, dynamic> json) =>
      RecoveryGroupGuardianModel(
        name: json['name'] as String,
        tag: json['tag'] as String,
        pubKey: PubKey(base64Decode(json['pub_key'] as String)),
        signPubKey: PubKey(base64Decode(json['sign_pub_key'] as String)),
      );

  static Map<String, dynamic> toJson(RecoveryGroupGuardianModel value) => {
        'name': value.name,
        'tag': value.tag,
        'pub_key': base64Encode(value.pubKey.data),
        'sign_pub_key': base64Encode(value.signPubKey.data),
      };
}

// RecoveryGroupSecretModel
// Do not save\serialize token or delete token at all?

@immutable
class RecoveryGroupSecretModel {
  final String name;
  final String token;

  const RecoveryGroupSecretModel({
    required this.name,
    this.token = '',
  })  : assert(name != ''),
        assert(token != '');

  factory RecoveryGroupSecretModel.fromJson(Map<String, dynamic> json) =>
      RecoveryGroupSecretModel(
        name: json['name'] as String,
        token: json['token'] as String,
      );

  static Map<String, dynamic> toJson(RecoveryGroupSecretModel value) => {
        'name': value.name,
        'token': value.token,
      };
}
