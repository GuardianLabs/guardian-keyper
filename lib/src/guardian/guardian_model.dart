import 'dart:convert';
import 'dart:typed_data';
import 'package:collection/collection.dart';

class SecretShard {
  final Uint8List secret;
  final Uint8List owner;
  final String groupId;

  const SecretShard({
    required this.secret,
    required this.owner,
    required this.groupId,
  });

  factory SecretShard.fromJson(Map<String, dynamic> json) => SecretShard(
        owner: base64Decode(json['owner']),
        groupId: json['group_id'],
        secret: base64Decode(json['secret']),
      );

  static Map<String, dynamic> toJson(SecretShard value) => {
        'owner': value.owner.toString(),
        'group_id': value.groupId,
        'secret': base64Encode(value.secret),
      };

  @override
  String toString() => '$groupId: ${base64Encode(owner)}';

  @override
  bool operator ==(Object other) =>
      other is SecretShard &&
      groupId == other.groupId &&
      owner == other.owner &&
      const IterableEquality().equals(secret, other.secret);

  @override
  int get hashCode => Object.hash(owner, groupId, secret); // TBD:
}
