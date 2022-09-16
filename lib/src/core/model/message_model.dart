part of 'core_model.dart';

enum OperationType { authPeer, getShard, setShard, takeOwnership }

enum MessageStatus { started, processed, accepted, rejected, failed }

@immutable
class MessageModel extends Equatable {
  static const currentVersion = 1;

  final PeerId peerId;
  final DateTime timestamp;
  final OperationType type;
  final MessageStatus status;
  final Nonce nonce;
  final SecretShardModel secretShard;

  MessageModel({
    PeerId? peerId,
    DateTime? timestamp,
    required this.type,
    this.status = MessageStatus.started,
    Nonce? nonce,
    SecretShardModel? secretShard,
  })  : peerId = peerId ?? PeerId.empty(),
        timestamp = timestamp ?? DateTime.now(),
        nonce = nonce ?? Nonce.empty(),
        secretShard = secretShard ?? SecretShardModel();

  @override
  List<Object> get props => [
        type,
        status,
        peerId,
        nonce,
        secretShard,
      ];

  bool get isStarted => status == MessageStatus.started;
  bool get isAccepted => status == MessageStatus.accepted;
  bool get isProcessed => status == MessageStatus.processed;
  bool get isRejected => status == MessageStatus.rejected;
  bool get isFailed => status == MessageStatus.failed;
  bool get isResolved =>
      status == MessageStatus.accepted || status == MessageStatus.rejected;
  bool get hasResponse =>
      status == MessageStatus.accepted ||
      status == MessageStatus.rejected ||
      status == MessageStatus.failed;

  String get aKey {
    switch (type) {
      case OperationType.authPeer:
        return nonce.asKey;
      case OperationType.setShard:
        return secretShard.groupId.asKey;
      case OperationType.getShard:
        return secretShard.groupId.asKey;
      case OperationType.takeOwnership:
        return nonce.asKey;
    }
  }

  factory MessageModel.fromBytes(Uint8List value, [PeerId? peerId]) {
    final u = Unpacker(value);
    if (u.unpackInt() != currentVersion) throw const FormatException();
    final timestamp =
        DateTime.fromMillisecondsSinceEpoch(u.unpackInt()!, isUtc: true);
    final type = OperationType.values[u.unpackInt()!];
    final status = MessageStatus.values[u.unpackInt()!];
    final nonce = Nonce(value: Uint8List.fromList(u.unpackBinary()));
    final secretShardBytes = Uint8List.fromList(u.unpackBinary());
    final secretShard = secretShardBytes.isEmpty
        ? SecretShardModel()
        : SecretShardModel.fromBytes(secretShardBytes);
    return MessageModel(
      peerId: peerId ?? secretShard.ownerId,
      timestamp: timestamp,
      type: type,
      status: status,
      nonce: nonce,
      secretShard: secretShard,
    );
  }

  Uint8List toBytes() {
    final p = Packer()
      ..packInt(currentVersion)
      ..packInt(timestamp.millisecondsSinceEpoch)
      ..packInt(type.index)
      ..packInt(status.index)
      ..packBinary(nonce.value)
      ..packBinary(secretShard.toBytes());
    return p.takeBytes();
  }

  MessageModel copyWith({
    PeerId? peerId,
    OperationType? type,
    MessageStatus? status,
    Nonce? nonce,
    SecretShardModel? secretShard,
  }) =>
      MessageModel(
        peerId: peerId ?? this.peerId,
        timestamp: timestamp,
        type: type ?? this.type,
        status: status ?? this.status,
        nonce: nonce ?? this.nonce,
        secretShard: secretShard ?? this.secretShard,
      );

  MessageModel process(PeerId ownerId, [String? ownerName]) => copyWith(
        peerId: ownerId,
        status: MessageStatus.processed,
        secretShard: secretShard.copyWith(
          ownerId: ownerId,
          ownerName: ownerName,
        ),
      );

  MessageModel clearSecret() =>
      copyWith(secretShard: secretShard.copyWith(value: ''));
}
