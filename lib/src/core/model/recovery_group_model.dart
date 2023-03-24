part of 'core_model.dart';

class RecoveryGroupModel extends Serializable {
  static const currentVersion = 1;
  static const boxName = 'vaults';
  static const typeId = 12;

  final int version;
  final GroupId id;
  final int maxSize;
  final int threshold;
  final PeerId ownerId;
  final Map<PeerId, String> guardians;
  final Map<SecretId, String> secrets;

  RecoveryGroupModel({
    this.version = currentVersion,
    GroupId? id,
    PeerId? ownerId,
    this.maxSize = 0,
    this.threshold = 0,
    this.guardians = const {},
    this.secrets = const {},
  })  : id = id ?? GroupId(),
        ownerId = ownerId ?? PeerId();

  @override
  List<Object> get props => [id];

  @override
  bool get isEmpty => guardians.isEmpty;

  @override
  bool get isNotEmpty => guardians.isNotEmpty;

  String get aKey => id.asKey;

  int get size => guardians.length;

  int get redudancy => maxSize - threshold;

  bool get isFull => guardians.length == maxSize;
  bool get isNotFull => !isFull;

  bool get isRestoring => isNotFull && secrets.isNotEmpty;
  bool get isNotRestoring => !isRestoring;

  bool get isSelfGuarded => guardians.containsKey(ownerId);

  factory RecoveryGroupModel.fromBytes(List<int> value) {
    final u = Unpacker(value is Uint8List ? value : Uint8List.fromList(value));
    final version = u.unpackInt()!;
    switch (version) {
      case 1:
        return RecoveryGroupModel(
          version: version,
          id: GroupId.fromBytes(u.unpackBinary()),
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

  RecoveryGroupModel copyWith({
    PeerId? ownerId,
    Map<PeerId, String>? guardians,
    Map<SecretId, String>? secrets,
  }) =>
      RecoveryGroupModel(
        id: id,
        ownerId: ownerId ?? this.ownerId,
        maxSize: maxSize,
        threshold: threshold,
        guardians: guardians ?? this.guardians,
        secrets: secrets ?? this.secrets,
      );
}
