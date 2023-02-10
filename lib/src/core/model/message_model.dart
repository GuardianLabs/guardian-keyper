part of 'core_model.dart';

enum MessageCode { createGroup, getShard, setShard, takeGroup }

enum MessageStatus {
  requested,
  received,
  accepted,
  rejected,
  failed,
  duplicated,
}

const typeId2Type = {
  PeerAddressList.typeId: PeerAddressList.fromBytes,
  SecretShardModel.typeId: SecretShardModel.fromBytes,
  RecoveryGroupModel.typeId: RecoveryGroupModel.fromBytes,
};

const type2TypeId = {
  PeerAddressList: PeerAddressList.typeId,
  SecretShardModel: SecretShardModel.typeId,
  RecoveryGroupModel: RecoveryGroupModel.typeId,
};

class MessageModel extends Serializable {
  static const currentVersion = 2;
  static const boxName = 'messages';
  static const typeId = 11;

  static MessageModel? tryFromBase64(String value) {
    try {
      return MessageModel.fromBase64(value);
    } catch (_) {
      return null;
    }
  }

  static MessageModel? tryFromBytes(Uint8List? value) {
    if (value == null) return null;
    try {
      return MessageModel.fromBytes(value);
    } catch (_) {
      return null;
    }
  }

  final int version;
  final MessageId id;
  final PeerId peerId;
  final DateTime timestamp;
  final MessageCode code;
  final MessageStatus status;
  final int? payloadTypeId;
  final Serializable? payload;

  MessageModel({
    this.version = currentVersion,
    MessageId? id,
    PeerId? peerId,
    DateTime? timestamp,
    required this.code,
    this.status = MessageStatus.requested,
    this.payload,
  })  : peerId = peerId ?? PeerId(),
        timestamp = timestamp ?? DateTime.now(),
        payloadTypeId = type2TypeId[payload.runtimeType],
        id = id ?? MessageId();

  @override
  List<Object> get props => [id];

  @override
  bool get isEmpty => payload == null;

  @override
  bool get isNotEmpty => payload != null;

  String get aKey => id.asKey;

  SecretShardModel get secretShard => payload as SecretShardModel;

  RecoveryGroupModel get recoveryGroup => payload as RecoveryGroupModel;

  PeerId get ownerId {
    switch (payload.runtimeType) {
      case SecretShardModel:
        return (payload as SecretShardModel).ownerId;
      case RecoveryGroupModel:
        return (payload as RecoveryGroupModel).ownerId;
      default:
        throw const FormatException('Payload have no ownerId!');
    }
  }

  GroupId get groupId {
    switch (payload.runtimeType) {
      case SecretShardModel:
        return (payload as SecretShardModel).groupId;
      case RecoveryGroupModel:
        return (payload as RecoveryGroupModel).id;
      default:
        throw const FormatException('Payload have no groupId!');
    }
  }

  bool get isRequested => status == MessageStatus.requested;
  bool get isNotRequested => status != MessageStatus.requested;
  bool get isReceived => status == MessageStatus.received;
  bool get isNotReceived => status != MessageStatus.received;
  bool get isAccepted => status == MessageStatus.accepted;
  bool get isRejected => status == MessageStatus.rejected;
  bool get isFailed => status == MessageStatus.failed;
  bool get isDuplicated => status == MessageStatus.duplicated;

  bool get isResolved =>
      status == MessageStatus.accepted || status == MessageStatus.rejected;

  bool get hasResponse =>
      status == MessageStatus.accepted ||
      status == MessageStatus.rejected ||
      status == MessageStatus.failed;

  bool get hasNoResponse =>
      status == MessageStatus.requested || status == MessageStatus.received;

  @override
  factory MessageModel.fromBase64(String value) =>
      MessageModel.fromBytes(base64Decode(value));

  @override
  factory MessageModel.fromBytes(List<int> value) {
    final u = Unpacker(value is Uint8List ? value : Uint8List.fromList(value));
    final version = u.unpackInt()!;
    switch (version) {
      case 1:
        final timestamp = DateTime.fromMillisecondsSinceEpoch(
          u.unpackInt()!,
          isUtc: true,
        );
        final code = MessageCode.values[u.unpackInt()!];
        final status = MessageStatus.values[u.unpackInt()!];
        final id = MessageId(token: Uint8List.fromList(u.unpackBinary()));
        final secretShard = SecretShardModel.fromBytes(u.unpackBinary());
        return MessageModel(
          version: version,
          id: id,
          peerId: secretShard.ownerId,
          timestamp: timestamp,
          code: code,
          status: status,
          payload: code == MessageCode.getShard || code == MessageCode.setShard
              ? secretShard
              : RecoveryGroupModel(
                  id: secretShard.groupId,
                  ownerId: secretShard.ownerId,
                ),
        );

      case 2:
        final id = MessageId.fromBytes(u.unpackBinary());
        final peerId = PeerId.fromBytes(u.unpackBinary());
        final timestamp =
            DateTime.fromMillisecondsSinceEpoch(u.unpackInt()!, isUtc: true);
        final code = MessageCode.values[u.unpackInt()!];
        final status = MessageStatus.values[u.unpackInt()!];
        final payloadTypeId = u.unpackInt();
        final payloadRaw = u.unpackBinary();
        final payload = typeId2Type[payloadTypeId]?.call(payloadRaw);
        return MessageModel(
          version: version,
          id: id,
          peerId: peerId,
          timestamp: timestamp,
          code: code,
          status: status,
          payload: payload,
        );

      default:
        throw const FormatException('Unsupported version of MessageModel!');
    }
  }

  @override
  Uint8List toBytes() {
    final p = Packer()
      ..packInt(currentVersion)
      ..packBinary(id.toBytes())
      ..packBinary(peerId.toBytes())
      ..packInt(timestamp.millisecondsSinceEpoch)
      ..packInt(code.index)
      ..packInt(status.index)
      ..packInt(payloadTypeId)
      ..packBinary(payload?.toBytes());
    return p.takeBytes();
  }

  MessageModel copyWith({
    PeerId? peerId,
    MessageStatus? status,
    Serializable? payload,
  }) =>
      MessageModel(
        version: version,
        id: id,
        peerId: peerId ?? this.peerId,
        timestamp: timestamp,
        code: code,
        status: status ?? this.status,
        payload: payload ?? this.payload,
      );
}
