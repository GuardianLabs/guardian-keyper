import 'package:flutter/foundation.dart';
import 'package:messagepack/messagepack.dart';

import 'package:guardian_keyper/src/core/domain/entity/core_model.dart';

class VaultId extends IdBase {
  static const currentVersion = 1;

  VaultId({super.name, Uint8List? token})
      : super(token: token ?? IdBase.getNewToken(length: 8));

  factory VaultId.fromBytes(List<int> token) {
    final u = Unpacker(token is Uint8List ? token : Uint8List.fromList(token));
    final version = u.unpackInt()!;
    if (version != currentVersion) throw const FormatException();
    return VaultId(
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

  VaultId copyWith({String? name}) => VaultId(
        token: token,
        name: name ?? this.name,
      );
}

class VaultModel extends Serializable {
  static const currentVersion = 1;
  static const typeId = 12;

  final int version;
  final VaultId id;
  final int maxSize;
  final int threshold;
  final PeerId ownerId;
  final Map<PeerId, String> guardians;
  final Map<SecretId, String> secrets;

  VaultModel({
    this.version = currentVersion,
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

  @override
  bool get isEmpty => guardians.isEmpty;

  String get aKey => id.asKey;

  int get size => guardians.length;
  int get missed => maxSize - size;
  int get redudancy => maxSize - threshold;

  bool get isFull => guardians.length == maxSize;
  bool get isNotFull => !isFull;

  bool get hasQuorum => size >= threshold;
  bool get hasNoQuorum => size < threshold;

  bool get isRestricted => isNotFull && secrets.isNotEmpty;
  bool get isNotRestricted => !isRestricted;

  bool get hasSecrets => secrets.isNotEmpty;
  bool get hasNoSecrets => secrets.isEmpty;

  bool get isSelfGuarded => guardians.containsKey(ownerId);

  factory VaultModel.fromBytes(List<int> value) {
    final u = Unpacker(value is Uint8List ? value : Uint8List.fromList(value));
    final version = u.unpackInt()!;
    switch (version) {
      case 1:
        return VaultModel(
          version: version,
          id: VaultId.fromBytes(u.unpackBinary()),
          maxSize: u.unpackInt()!,
          threshold: u.unpackInt()!,
          ownerId: PeerId.fromBytes(u.unpackBinary()),
          guardians: u.unpackMap().map<PeerId, String>((k, v) =>
              MapEntry(PeerId.fromBytes(k as List<int>), v as String)),
          secrets: u.unpackMap().map<SecretId, String>((k, v) =>
              MapEntry(SecretId.fromBytes(k as List<int>), v as String)),
        );

      default:
        throw const FormatException(
          'Unsupported version of RecoveryGroupModel!',
        );
    }
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
