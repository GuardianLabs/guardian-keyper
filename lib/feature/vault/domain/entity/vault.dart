import 'package:flutter/foundation.dart';
import 'package:messagepack/messagepack.dart';

import 'package:guardian_keyper/domain/entity/serializable.dart';
import 'package:guardian_keyper/feature/network/domain/entity/peer_id.dart';

import 'secret_id.dart';
import 'vault_id.dart';

@immutable
class Vault extends Serializable {
  static const currentVersion = 1;
  static const typeId = 12;

  Vault({
    required this.ownerId,
    VaultId? id,
    this.maxSize = 0,
    this.threshold = 0,
    this.secrets = const {},
    this.guardians = const {},
    this.version = currentVersion,
  }) : id = id ?? VaultId();

  final VaultId id;
  final PeerId ownerId;
  final int version;
  final int maxSize;
  final int threshold;
  final Map<PeerId, String> guardians;
  final Map<SecretId, String> secrets;

  late final String aKey = id.asKey;

  @override
  bool operator ==(Object other) =>
      other is Vault &&
      runtimeType == other.runtimeType &&
      id.hashCode == other.id.hashCode;

  @override
  int get hashCode => Object.hash(runtimeType, id.hashCode);

  int get size => guardians.length;
  int get missed => maxSize - size;
  int get redudancy => maxSize - threshold;

  bool get hasQuorum => size >= threshold;
  bool get isSelfGuarded => guardians.containsKey(ownerId);

  bool get isFull => guardians.length == maxSize;
  bool get isNotFull => !isFull;

  bool get hasSecrets => secrets.isNotEmpty;
  bool get hasNoSecrets => secrets.isEmpty;

  bool get isRestricted => isNotFull && secrets.isNotEmpty;
  bool get isNotRestricted => !isRestricted;

  factory Vault.fromBytes(List<int> value) {
    final u = Unpacker(value is Uint8List ? value : Uint8List.fromList(value));
    final version = u.unpackInt()!;
    return switch (version) {
      currentVersion => Vault(
          version: version,
          id: VaultId.fromBytes(u.unpackBinary()),
          maxSize: u.unpackInt()!,
          threshold: u.unpackInt()!,
          ownerId: PeerId.fromBytes(u.unpackBinary()),
          guardians: u.unpackMap().map<PeerId, String>((k, v) =>
              MapEntry(PeerId.fromBytes(k! as List<int>), v! as String)),
          secrets: u.unpackMap().map<SecretId, String>((k, v) =>
              MapEntry(SecretId.fromBytes(k! as List<int>), v! as String)),
        ),
      _ => throw const FormatException('Unsupported version of Vault!'),
    };
  }

  @override
  Uint8List toBytes() {
    final p = Packer()
      ..packInt(currentVersion)
      ..packBinary(id.toBytes())
      ..packInt(maxSize)
      ..packInt(threshold)
      ..packBinary(ownerId.toBytes())
      ..packMapLength(guardians.length);
    for (final e in guardians.entries) {
      p
        ..packBinary(e.key.toBytes())
        ..packString(e.value);
    }
    p.packMapLength(secrets.length);
    for (final e in secrets.entries) {
      p
        ..packBinary(e.key.toBytes())
        ..packString(e.value);
    }
    return p.takeBytes();
  }

  Vault copyWith({
    PeerId? ownerId,
    Map<PeerId, String>? guardians,
    Map<SecretId, String>? secrets,
  }) =>
      Vault(
        version: version,
        id: id,
        ownerId: ownerId ?? this.ownerId,
        maxSize: maxSize,
        threshold: threshold,
        guardians: guardians ?? this.guardians,
        secrets: secrets ?? this.secrets,
      );
}
