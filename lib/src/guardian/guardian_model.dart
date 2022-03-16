import 'dart:typed_data' show Uint8List;
import 'dart:convert' show base64Decode, base64Encode;
import 'package:flutter/foundation.dart' show immutable;
import 'package:collection/collection.dart' show IterableEquality;

@immutable
class SecretShard {
  final Uint8List value;
  final Uint8List owner;
  final Uint8List groupId;

  const SecretShard({
    required this.value,
    required this.owner,
    required this.groupId,
  });

  factory SecretShard.empty() => SecretShard(
        value: Uint8List(0),
        owner: Uint8List(0),
        groupId: Uint8List(0),
      );

  factory SecretShard.fromJson(Map<String, dynamic> json) => SecretShard(
        owner: base64Decode(json['owner']),
        groupId: base64Decode(json['group_id']),
        value: base64Decode(json['secret']),
      );

  Map<String, dynamic> toJson() => {
        'owner': base64Encode(owner),
        'group_id': base64Encode(groupId),
        'secret': base64Encode(value),
      };

  @override
  String toString() => '$groupId: ${base64Encode(owner)}';

  @override
  bool operator ==(Object other) =>
      other is SecretShard &&
      const IterableEquality().equals(groupId, other.groupId) &&
      const IterableEquality().equals(owner, other.owner) &&
      const IterableEquality().equals(value, other.value);

  @override
  int get hashCode => Object.hashAll([owner, groupId, value]);
}
