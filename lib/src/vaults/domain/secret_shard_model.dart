import 'package:flutter/foundation.dart';
import 'package:messagepack/messagepack.dart';

import 'package:guardian_keyper/src/core/domain/entity/core_model.dart';

class SecretId extends IdBase {
  static const currentVersion = 1;

  SecretId({Uint8List? token, super.name})
      : super(token: token ?? IdBase.getNewToken(length: 8));

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
  final VaultId vaultId;
  final int groupSize;
  final int groupThreshold;
  final String shard;

  const SecretShardModel({
    this.version = currentVersion,
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

  @override
  bool get isEmpty => shard.isEmpty;

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
          vaultId: VaultId.fromBytes(u.unpackBinary()),
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
