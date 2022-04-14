import 'dart:typed_data' show Uint8List;
import 'dart:convert' show base64Decode, base64Encode;
import 'package:flutter/foundation.dart' show immutable;

@immutable
class SecretShard {
  final Uint8List value;
  final Uint8List owner;
  final Uint8List groupId;
  final String groupName;
  final String ownerName;
  final int groupSize;
  final int groupThreshold;

  const SecretShard({
    required this.value,
    required this.owner,
    required this.groupId,
    required this.groupName,
    required this.ownerName,
    required this.groupSize,
    required this.groupThreshold,
  });

  factory SecretShard.empty() => SecretShard(
        value: Uint8List(0),
        owner: Uint8List(0),
        groupId: Uint8List(0),
        groupName: '',
        ownerName: '',
        groupSize: 0,
        groupThreshold: 0,
      );

  factory SecretShard.fromJson(Map<String, dynamic> json) => SecretShard(
        owner: base64Decode(json['owner']),
        value: base64Decode(json['secret']),
        groupId: base64Decode(json['group_id']),
        groupName: json['group_name'],
        ownerName: json['owner_name'],
        groupSize: json['group_size'],
        groupThreshold: json['group_threshold'],
      );

  Map<String, dynamic> toJson() => {
        'owner': base64Encode(owner),
        'secret': base64Encode(value),
        'group_id': base64Encode(groupId),
        'group_name': groupName,
        'owner_name': ownerName,
        'group_size': groupSize,
        'group_threshold': groupThreshold,
      };

  @override
  String toString() => '$groupName of $ownerName}';

  @override
  bool operator ==(Object other) =>
      other is SecretShard && hashCode == other.hashCode;

  @override
  int get hashCode => Object.hashAll([
        owner,
        ownerName,
        groupId,
        groupName,
        groupSize,
        groupThreshold,
        value,
      ]);
}
