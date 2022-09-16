part of 'core_model.dart';

@immutable
class SecretShardModel extends Equatable {
  static const currentVersion = 1;

  final String value;
  final String ownerName;
  final PeerId ownerId;
  final String groupName;
  final GroupId groupId;
  final int groupSize;
  final int groupThreshold;

  @override
  List<Object> get props => [groupId, ownerId];

  String get asKey => base64UrlEncode(groupId.value);

  bool get isEmpty =>
      ownerId.isEmpty &&
      groupId.isEmpty &&
      ownerName.isEmpty &&
      groupName.isEmpty &&
      value.isEmpty;

  SecretShardModel({
    this.value = '',
    PeerId? ownerId,
    this.ownerName = '',
    GroupId? groupId,
    this.groupName = '',
    this.groupSize = 0,
    this.groupThreshold = 0,
  })  : ownerId = ownerId ?? PeerId.empty(),
        groupId = groupId ?? GroupId.empty();

  factory SecretShardModel.fromBytes(Uint8List bytes) {
    final u = Unpacker(bytes);
    if (u.unpackInt() != currentVersion) throw const FormatException();
    return SecretShardModel(
      value: u.unpackString()!,
      ownerId: PeerId(value: Uint8List.fromList(u.unpackBinary())),
      ownerName: u.unpackString()!,
      groupId: GroupId(value: Uint8List.fromList(u.unpackBinary())),
      groupName: u.unpackString()!,
      groupSize: u.unpackInt()!,
      groupThreshold: u.unpackInt()!,
    );
  }

  Uint8List toBytes() {
    final p = Packer()
      ..packInt(currentVersion)
      ..packString(value)
      ..packBinary(ownerId.value)
      ..packString(ownerName)
      ..packBinary(groupId.value)
      ..packString(groupName)
      ..packInt(groupSize)
      ..packInt(groupThreshold);
    return p.takeBytes();
  }

  SecretShardModel copyWith({
    String? value,
    PeerId? ownerId,
    String? ownerName,
    GroupId? groupId,
    String? groupName,
    int? groupSize,
    int? groupThreshold,
  }) =>
      SecretShardModel(
        value: value ?? this.value,
        ownerId: ownerId ?? this.ownerId,
        ownerName: ownerName ?? this.ownerName,
        groupId: groupId ?? this.groupId,
        groupName: groupName ?? this.groupName,
        groupSize: groupSize ?? this.groupSize,
        groupThreshold: groupThreshold ?? this.groupThreshold,
      );

  @override
  String toString() => '$groupName of $ownerName}';
}
