part of 'core_model.dart';

enum RecoveryGroupType { devices, fiduciaries }

@immutable
class RecoveryGroupModel extends Equatable {
  static const currentVersion = 1;

  final GroupId id;
  final String name;
  final RecoveryGroupType type;
  final int maxSize;
  final bool hasSecret;
  final bool isRestoring;
  final Map<PeerId, GuardianModel> guardians;

  @override
  List<Object> get props => [id];

  int get currentSize => guardians.length;

  int get threshold => maxSize == 5 ? 3 : 2;

  int get neededMore => maxSize - currentSize;

  bool get hasMinimal => guardians.length >= threshold;

  bool get isFull => guardians.length == maxSize;

  bool get isNotFull => guardians.length < maxSize;

  bool get isMissed => guardians.length < threshold;

  bool get isNotRestoring => !isRestoring;

  bool get canAddGuardian => !hasSecret && !isRestoring && !isFull;

  bool get canAddSecret => !hasSecret && isFull && !isRestoring;

  bool get canRecoverSecret => hasSecret && hasMinimal;

  const RecoveryGroupModel({
    required this.id,
    required this.name,
    this.type = RecoveryGroupType.devices,
    this.maxSize = 3,
    this.hasSecret = false,
    this.isRestoring = false,
    this.guardians = const {},
  }) : assert(name != '');

  factory RecoveryGroupModel.fromBytes(Uint8List value) {
    final u = Unpacker(value);
    if (u.unpackInt() != currentVersion) throw const FormatException();
    return RecoveryGroupModel(
      id: GroupId(value: Uint8List.fromList(u.unpackBinary())),
      name: u.unpackString()!,
      type: RecoveryGroupType.values[u.unpackInt()!],
      maxSize: u.unpackInt()!,
      hasSecret: u.unpackBool()!,
      isRestoring: u.unpackBool()!,
      guardians: Map.fromEntries(u
          .unpackList()
          .map<GuardianModel>((e) =>
              GuardianModel.fromBytes(Uint8List.fromList(e as List<int>)))
          .map((g) => MapEntry(g.peerId, g))),
    );
  }

  Uint8List toBytes() {
    final guardiansAsBytes = guardians.values.map((e) => e.toBytes());
    final p = Packer()
      ..packInt(currentVersion)
      ..packBinary(id.value)
      ..packString(name)
      ..packInt(type.index)
      ..packInt(maxSize)
      ..packBool(hasSecret)
      ..packBool(isRestoring)
      ..packListLength(guardiansAsBytes.length);
    guardiansAsBytes.forEach(p.packBinary);
    return p.takeBytes();
  }

  RecoveryGroupModel addGuardian(GuardianModel guardian) {
    if (isFull) throw RecoveryGroupGuardianLimitexhausted();
    if (guardians.containsKey(guardian.peerId)) {
      throw RecoveryGroupGuardianAlreadyExists();
    }
    return RecoveryGroupModel(
      id: id,
      name: name,
      type: type,
      maxSize: maxSize,
      guardians: {...guardians, guardian.peerId: guardian},
      isRestoring: isFull ? false : isRestoring,
      hasSecret: hasSecret,
    );
  }

  RecoveryGroupModel completeGroup() => RecoveryGroupModel(
        id: id,
        name: name,
        type: type,
        maxSize: maxSize,
        guardians: guardians,
        isRestoring: isRestoring,
        hasSecret: true,
      );
}

class RecoveryGroupGuardianAlreadyExists implements Exception {
  static const description =
      'Guardian with given name already exists in that group!';
}

class RecoveryGroupGuardianLimitexhausted implements Exception {
  static const description = 'Guardian group size limit exhausted!';
}

@immutable
class GuardianModel extends Equatable {
  static const currentVersion = 1;

  final PeerId peerId;
  final String name;
  final String tag;

  const GuardianModel({
    required this.peerId,
    required this.name,
    this.tag = '',
  }) : assert(name != '');

  @override
  List<Object> get props => [peerId];

  factory GuardianModel.fromBytes(Uint8List value) {
    final u = Unpacker(value);
    if (u.unpackInt() != currentVersion) throw const FormatException();
    return GuardianModel(
      peerId: PeerId(value: Uint8List.fromList(u.unpackBinary())),
      name: u.unpackString()!,
      tag: u.unpackString()!,
    );
  }

  Uint8List toBytes() {
    final p = Packer()
      ..packInt(currentVersion)
      ..packBinary(peerId.value)
      ..packString(name)
      ..packString(tag);
    return p.takeBytes();
  }
}
