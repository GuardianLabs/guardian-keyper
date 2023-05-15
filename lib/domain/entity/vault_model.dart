import 'package:flutter/foundation.dart';
import 'package:messagepack/messagepack.dart';

import '_id/peer_id.dart';
import '_id/secret_id.dart';
import '_id/vault_id.dart';
import 'serializable.dart';

class VaultModel extends Serializable {
  static const currentVersion = 1;
  static const typeId = 12;

  final VaultId id;
  final PeerId ownerId;
  final int maxSize, threshold;
  final Map<PeerId, String> guardians;
  final Map<SecretId, String> secrets;

  VaultModel({
    VaultId? id,
    required this.ownerId,
    this.maxSize = 0,
    this.threshold = 0,
    this.guardians = const {},
    this.secrets = const {},
  }) : id = id ?? VaultId();

  @override
  bool operator ==(Object other) =>
      other is VaultModel &&
      runtimeType == other.runtimeType &&
      id.hashCode == other.id.hashCode;

  @override
  int get hashCode => Object.hash(runtimeType, id.hashCode);

  String get aKey => id.asKey;

  int get size => guardians.length;
  int get missed => maxSize - size;
  int get redudancy => maxSize - threshold;

  bool get isFull => guardians.length == maxSize;
  bool get isNotFull => !isFull;

  bool get hasQuorum => size >= threshold;

  bool get isRestricted => isNotFull && secrets.isNotEmpty;
  bool get isNotRestricted => !isRestricted;

  bool get hasSecrets => secrets.isNotEmpty;

  bool get isSelfGuarded => guardians.containsKey(ownerId);

  factory VaultModel.fromBytes(List<int> value) {
    final u = Unpacker(value is Uint8List ? value : Uint8List.fromList(value));
    if (u.unpackInt() != currentVersion) {
      throw const FormatException('Unsupported version of VaultModel!');
    }
    return VaultModel(
      id: VaultId.fromBytes(u.unpackBinary()),
      maxSize: u.unpackInt()!,
      threshold: u.unpackInt()!,
      ownerId: PeerId.fromBytes(u.unpackBinary()),
      guardians: u.unpackMap().map<PeerId, String>(
          (k, v) => MapEntry(PeerId.fromBytes(k as List<int>), v as String)),
      secrets: u.unpackMap().map<SecretId, String>(
          (k, v) => MapEntry(SecretId.fromBytes(k as List<int>), v as String)),
    );
  }

  @override
  Uint8List toBytes() {
    final p = Packer()
      ..packInt(currentVersion)
      ..packBinary(id.toBytes())
      ..packInt(maxSize)
      ..packInt(threshold)
      ..packBinary(ownerId.toBytes());
    p.packMapLength(guardians.length);
    for (final e in guardians.entries) {
      p.packBinary(e.key.toBytes());
      p.packString(e.value);
    }
    p.packMapLength(secrets.length);
    for (final e in secrets.entries) {
      p.packBinary(e.key.toBytes());
      p.packString(e.value);
    }
    return p.takeBytes();
  }

  VaultModel copyWith({
    PeerId? ownerId,
    Map<PeerId, String>? guardians,
    Map<SecretId, String>? secrets,
  }) =>
      VaultModel(
        id: id,
        ownerId: ownerId ?? this.ownerId,
        maxSize: maxSize,
        threshold: threshold,
        guardians: guardians ?? this.guardians,
        secrets: secrets ?? this.secrets,
      );
}
