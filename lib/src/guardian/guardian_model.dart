import 'dart:typed_data' show Uint8List;
import 'dart:convert' show base64Decode, base64Encode;
import 'package:flutter/foundation.dart' show immutable;
import 'package:collection/collection.dart' show IterableEquality;

@immutable
class SecretShard {
  final Uint8List secret;
  final Uint8List owner;
  final Uint8List groupId;

  const SecretShard({
    required this.secret,
    required this.owner,
    required this.groupId,
  });

  factory SecretShard.empty() => SecretShard(
        secret: Uint8List(0),
        owner: Uint8List(0),
        groupId: Uint8List(0),
      );

  factory SecretShard.fromJson(Map<String, dynamic> json) => SecretShard(
        owner: base64Decode(json['owner']),
        groupId: base64Decode(json['group_id']),
        secret: base64Decode(json['secret']),
      );

  Map<String, dynamic> toJson() => {
        'owner': base64Encode(owner),
        'group_id': base64Encode(groupId),
        'secret': base64Encode(secret),
      };

  @override
  String toString() => '$groupId: ${base64Encode(owner)}';

  @override
  bool operator ==(Object other) =>
      other is SecretShard &&
      const IterableEquality().equals(groupId, other.groupId) &&
      const IterableEquality().equals(owner, other.owner) &&
      const IterableEquality().equals(secret, other.secret);

  @override
  int get hashCode => Object.hashAll([owner, groupId, secret]);
}
