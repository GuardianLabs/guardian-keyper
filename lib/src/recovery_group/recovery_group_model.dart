import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

import '../core/model/p2p_model.dart';

enum RecoveryGroupType { devices, fiduciaries }

class GroupID extends RawToken {
  static const length = 8;

  const GroupID(Uint8List data) : super(data: data, len: length);
}

@immutable
class RecoveryGroupModel {
  final GroupID id;
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
      id: GroupID(base64Decode(json['id'] as String)),
      name: json['name'] as String,
      type: RecoveryGroupType.values.byName(json['type']),
      size: json['size'] as int,
      threshold: json['threshold'] as int,
      secrets: secretsMap.cast<String, RecoveryGroupSecretModel>(),
      guardians: guardiansMap.cast<String, RecoveryGroupGuardianModel>(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': base64Encode(id.data),
        'name': name,
        'type': type.name,
        'size': size,
        'threshold': threshold,
        'secrets': secrets,
        'guardians': guardians,
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

  Map<String, dynamic> toJson() => {
        'name': name,
        'tag': tag,
        'pub_key': base64Encode(pubKey.data),
        'sign_pub_key': base64Encode(signPubKey.data),
      };
}

// RecoveryGroupSecretModel

@immutable
class RecoveryGroupSecretModel {
  final int id;
  final String name;
  final String token;

  const RecoveryGroupSecretModel({
    required this.name,
    this.token = '',
    this.id = 0,
  }) : assert(name != '');

  factory RecoveryGroupSecretModel.fromJson(Map<String, dynamic> json) =>
      RecoveryGroupSecretModel(
        id: json['id'] as int,
        name: json['name'] as String,
      );

  Map<String, dynamic> toJson() => {
        'id': token.hashCode,
        'name': name,
      };
}
