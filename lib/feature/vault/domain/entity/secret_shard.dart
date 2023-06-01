import 'package:flutter/foundation.dart';
import 'package:messagepack/messagepack.dart';

import 'package:guardian_keyper/domain/entity/serializable.dart';
import 'package:guardian_keyper/feature/network/domain/entity/peer_id.dart';

import 'secret_id.dart';
import 'vault_id.dart';

class SecretShard extends Serializable {
  static const currentVersion = 1;
  static const typeId = 11;

  SecretShard({
    this.version = currentVersion,
    required this.id,
    required this.ownerId,
    required this.vaultId,
    required this.groupSize,
    required this.groupThreshold,
    required this.shard,
  });

  final SecretId id;
  final PeerId ownerId;
  final VaultId vaultId;
  final int version, groupSize, groupThreshold;
  final String shard;

  late final String aKey = id.asKey;

  @override
  bool operator ==(Object other) =>
      other is SecretShard &&
      runtimeType == other.runtimeType &&
      id.hashCode == other.id.hashCode;

  @override
  int get hashCode => Object.hash(runtimeType, id.hashCode);

  factory SecretShard.fromBytes(List<int> bytes) {
    final u = Unpacker(bytes is Uint8List ? bytes : Uint8List.fromList(bytes));
    final version = u.unpackInt()!;
    return switch (version) {
      currentVersion => SecretShard(
          version: version,
          id: SecretId.fromBytes(u.unpackBinary()),
          ownerId: PeerId.fromBytes(u.unpackBinary()),
          vaultId: VaultId.fromBytes(u.unpackBinary()),
          groupSize: u.unpackInt()!,
          groupThreshold: u.unpackInt()!,
          shard: u.unpackString()!,
        ),
      _ => throw const FormatException('Unsupported version of SecretShard'),
    };
  }

  @override
  Uint8List toBytes() {
    final p = Packer()
      ..packInt(currentVersion)
      ..packBinary(id.toBytes())
      ..packBinary(ownerId.toBytes())
      ..packBinary(vaultId.toBytes())
      ..packInt(groupSize)
      ..packInt(groupThreshold)
      ..packString(shard);
    return p.takeBytes();
  }

  SecretShard copyWith({
    PeerId? ownerId,
    String? shard,
  }) =>
      SecretShard(
        version: version,
        id: id,
        ownerId: ownerId ?? this.ownerId,
        vaultId: vaultId,
        groupSize: groupSize,
        groupThreshold: groupThreshold,
        shard: shard ?? this.shard,
      );

  @override
  String toString() => '${vaultId.name} of ${ownerId.name}';
}
