import 'package:flutter/foundation.dart';
import 'package:messagepack/messagepack.dart';

import 'package:guardian_keyper/domain/entity/serializable.dart';
import 'package:guardian_keyper/domain/entity/peer_id.dart';

import 'secret_id.dart';
import 'vault_id.dart';

@immutable
class SecretShard extends Serializable {
  static const currentVersion = 1;
  static const typeId = 11;

  SecretShard({
    required this.id,
    required this.shard,
    required this.ownerId,
    required this.vaultId,
    required this.vaultSize,
    required this.vaultThreshold,
    this.version = currentVersion,
  });

  final SecretId id;
  final PeerId ownerId;
  final VaultId vaultId;
  final int version;
  final int vaultSize;
  final int vaultThreshold;
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
          vaultSize: u.unpackInt()!,
          vaultThreshold: u.unpackInt()!,
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
      ..packInt(vaultSize)
      ..packInt(vaultThreshold)
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
        vaultSize: vaultSize,
        vaultThreshold: vaultThreshold,
        shard: shard ?? this.shard,
      );

  @override
  String toString() => '${vaultId.name} of ${ownerId.name}';
}
