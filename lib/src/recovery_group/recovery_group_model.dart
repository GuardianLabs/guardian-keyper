import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:p2plib/p2plib.dart' show RawToken, PubKey;

import '../core/model/p2p_model.dart' show RecoveryGroupType;

class GroupID extends RawToken {
  static const length = 8;

  const GroupID(Uint8List value) : super(data: value, len: length);
}

@immutable
class RecoveryGroupModel extends Equatable {
  static const currentVersion = 1;

  final minSize = 2; //(3) for test purposes
  final maxSize = 3; //(5) for test purposes
  final GroupID id;
  final String name;
  final RecoveryGroupType type;
  final bool isRestoring;
  final int? fixedSize;
  final Map<String, RecoveryGroupGuardianModel> guardians;
  final Map<String, RecoveryGroupSecretModel> secrets;

  const RecoveryGroupModel({
    required this.id,
    required this.name,
    this.type = RecoveryGroupType.devices,
    this.isRestoring = false,
    this.fixedSize,
    this.secrets = const {},
    this.guardians = const {},
  }) : assert(name != '');

  factory RecoveryGroupModel.fromJson(Map<String, dynamic> json) {
    // switch (json['version']) {
    //   case null:
    //     break;
    //   default:
    // }
    Map<String, dynamic> secretsMap = json['secrets'];
    secretsMap
        .updateAll((key, value) => RecoveryGroupSecretModel.fromJson(value));

    Map<String, dynamic> guardiansMap = json['guardians'];
    guardiansMap
        .updateAll((key, value) => RecoveryGroupGuardianModel.fromJson(value));

    return RecoveryGroupModel(
      id: GroupID(base64Decode(json['id'])),
      name: json['name'],
      type: RecoveryGroupType.values.byName(json['type']),
      isRestoring: json['is_restoring'] ?? false,
      fixedSize: json['fixed_size'],
      secrets: secretsMap.cast<String, RecoveryGroupSecretModel>(),
      guardians: guardiansMap.cast<String, RecoveryGroupGuardianModel>(),
    );
  }

  Map<String, dynamic> toJson() => {
        'version': currentVersion,
        'id': base64Encode(id.data),
        'name': name,
        'type': type.name,
        'is_restoring': isRestoring,
        'fixed_size': fixedSize,
        'secrets': secrets,
        'guardians': guardians,
      };

  RecoveryGroupModel addGuardian(RecoveryGroupGuardianModel guardian) {
    bool _isRestoring = isRestoring;
    if (isRestoring) {
      if (fixedSize == null) throw Exception('Size should be fixed!');
      if (guardians.length == fixedSize) _isRestoring = false;
    }
    if (guardians.containsKey(guardian.name)) {
      throw RecoveryGroupGuardianAlreadyExists();
    }
    if (guardians.length >= (fixedSize ?? maxSize)) {
      throw RecoveryGroupGuardianLimitexhausted();
    }
    return RecoveryGroupModel(
      id: id,
      name: name,
      type: type,
      isRestoring: _isRestoring,
      fixedSize: fixedSize,
      secrets: secrets,
      guardians: {...guardians, guardian.name: guardian},
    );
  }

  RecoveryGroupModel addSecret(RecoveryGroupSecretModel secret) {
    // if (secrets.containsKey(secret.name)) {
    //   throw RecoveryGroupSecretAlreadyExists();
    // }
    return RecoveryGroupModel(
      id: id,
      name: name,
      type: type,
      isRestoring: isRestoring,
      fixedSize: guardians.length,
      secrets: {...secrets, secret.name: secret},
      guardians: guardians,
    );
  }

  int get size => fixedSize ?? guardians.length;

  // int get threshold => guardians.length == maxSize ? 3 : 2;
  int get threshold => 2; // for test purposes

  bool get isCompleted => secrets.isNotEmpty;

  bool get hasMinimal => guardians.length >= minSize;

  bool get isMissed => guardians.length < threshold;

  @override
  List<Object> get props => [id, name, type];
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
class RecoveryGroupGuardianModel extends Equatable {
  static const currentVersion = 1;

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
      // switch (json['version']) {
      //   case null:
      //     break;
      //   default:
      // }
      RecoveryGroupGuardianModel(
        name: json['name'],
        tag: json['tag'],
        pubKey: PubKey(base64Decode(json['pub_key'])),
        signPubKey: PubKey(base64Decode(json['sign_pub_key'])),
      );

  Map<String, dynamic> toJson() => {
        'version': currentVersion,
        'name': name,
        'tag': tag,
        'pub_key': base64Encode(pubKey.data),
        'sign_pub_key': base64Encode(signPubKey.data),
      };

  @override
  List<Object> get props => [pubKey, signPubKey];
}

// RecoveryGroupSecretModel

@immutable
class RecoveryGroupSecretModel extends Equatable {
  static const currentVersion = 1;

  final int id;
  final String name;
  final String token;

  const RecoveryGroupSecretModel({
    required this.name,
    this.token = '',
    this.id = 0,
  }) : assert(name != '');

  factory RecoveryGroupSecretModel.fromJson(Map<String, dynamic> json) =>
      // switch (json['version']) {
      //   case null:
      //     break;
      //   default:
      // }
      RecoveryGroupSecretModel(
        id: json['id'],
        name: json['name'],
      );

  Map<String, dynamic> toJson() => {
        'version': currentVersion,
        'id': token.hashCode,
        'name': name,
      };

  @override
  List<Object> get props => [name];
}
