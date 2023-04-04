import 'package:flutter/foundation.dart';
import 'package:messagepack/messagepack.dart';

import '/src/core/data/core_model.dart';
import '/src/core/utils/random_utils.dart';

class SecretId extends IdBase {
  static const currentVersion = 1;
  static const size = 8;

  SecretId({Uint8List? token, required super.name})
      : super(token: token ?? getRandomBytes(size));

  factory SecretId.fromBytes(List<int> token) {
    final u = Unpacker(token is Uint8List ? token : Uint8List.fromList(token));
    final version = u.unpackInt()!;
    if (version != currentVersion) throw const FormatException();
    return SecretId(
      token: Uint8List.fromList(u.unpackBinary()),
      name: u.unpackString()!,
    );
  }

  @override
  Uint8List toBytes() {
    final p = Packer()
      ..packInt(currentVersion)
      ..packBinary(token)
      ..packString(name);
    return p.takeBytes();
  }

  SecretId copyWith({String? name}) => SecretId(
        token: token,
        name: name ?? this.name,
      );
}

class SecretShardModel extends Serializable {
  static const currentVersion = 1;
  static const typeId = 11;

  final int version;
  final SecretId id;
  final PeerId ownerId;
  final VaultId groupId;
  final int groupSize;
  final int groupThreshold;
  final String shard;

  const SecretShardModel({
    this.version = currentVersion,
    required this.id,
    required this.ownerId,
    required this.groupId,
    required this.groupSize,
    required this.groupThreshold,
    required this.shard,
  });

  @override
  List<Object> get props => [id];

  @override
  bool get isEmpty => shard.isEmpty;

  @override
  bool get isNotEmpty => shard.isNotEmpty;

  String get aKey => id.asKey;

  factory SecretShardModel.fromBytes(List<int> bytes) {
    final u = Unpacker(bytes is Uint8List ? bytes : Uint8List.fromList(bytes));
    final version = u.unpackInt()!;
    switch (version) {
      case 1:
        return SecretShardModel(
          version: version,
          id: SecretId.fromBytes(u.unpackBinary()),
          ownerId: PeerId.fromBytes(u.unpackBinary()),
          groupId: VaultId.fromBytes(u.unpackBinary()),
          groupSize: u.unpackInt()!,
          groupThreshold: u.unpackInt()!,
          shard: u.unpackString()!,
        );

      default:
        throw const FormatException('Unsupported version of SecretShardModel');
    }
  }

  @override
  Uint8List toBytes() {
    final p = Packer()
      ..packInt(currentVersion)
      ..packBinary(id.toBytes())
      ..packBinary(ownerId.toBytes())
      ..packBinary(groupId.toBytes())
      ..packInt(groupSize)
      ..packInt(groupThreshold)
      ..packString(shard);
    return p.takeBytes();
  }

  SecretShardModel copyWith({
    PeerId? ownerId,
    String? shard,
  }) =>
      SecretShardModel(
        id: id,
        ownerId: ownerId ?? this.ownerId,
        groupId: groupId,
        groupSize: groupSize,
        groupThreshold: groupThreshold,
        shard: shard ?? this.shard,
      );

  @override
  String toString() => '${groupId.name} of ${ownerId.name}';
}
