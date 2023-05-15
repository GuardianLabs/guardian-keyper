import 'package:flutter/foundation.dart';
import 'package:messagepack/messagepack.dart';

import '_id/peer_id.dart';
import '_id/secret_id.dart';
import '_id/vault_id.dart';
import 'serializable.dart';

class SecretShardModel extends Serializable {
  static const currentVersion = 1;
  static const typeId = 11;

  final SecretId id;
  final PeerId ownerId;
  final VaultId vaultId;
  final int groupSize, groupThreshold;
  final String shard;

  const SecretShardModel({
    required this.id,
    required this.ownerId,
    required this.vaultId,
    required this.groupSize,
    required this.groupThreshold,
    required this.shard,
  });

  @override
  bool operator ==(Object other) =>
      other is SecretShardModel &&
      runtimeType == other.runtimeType &&
      id.hashCode == other.id.hashCode;

  @override
  int get hashCode => Object.hash(runtimeType, id.hashCode);

  String get aKey => id.asKey;

  factory SecretShardModel.fromBytes(List<int> bytes) {
    final u = Unpacker(bytes is Uint8List ? bytes : Uint8List.fromList(bytes));
    if (u.unpackInt() != currentVersion) {
      throw const FormatException('Unsupported version of SecretShardModel');
    }
    return SecretShardModel(
      id: SecretId.fromBytes(u.unpackBinary()),
      ownerId: PeerId.fromBytes(u.unpackBinary()),
      vaultId: VaultId.fromBytes(u.unpackBinary()),
      groupSize: u.unpackInt()!,
      groupThreshold: u.unpackInt()!,
      shard: u.unpackString()!,
    );
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

  SecretShardModel copyWith({
    PeerId? ownerId,
    String? shard,
  }) =>
      SecretShardModel(
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
