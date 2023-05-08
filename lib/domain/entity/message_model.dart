import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:messagepack/messagepack.dart';

import 'package:guardian_keyper/domain/entity/_id/peer_id.dart';
import 'package:guardian_keyper/domain/entity/serializable.dart';
import 'package:guardian_keyper/domain/entity/vault_model.dart';
import 'package:guardian_keyper/domain/entity/secret_shard_model.dart';

import '_id/message_id.dart';
import '_id/vault_id.dart';

enum MessageStatus {
  created,
  received,
  accepted,
  rejected,
  failed,
  duplicated,
}

enum MessageCode { createGroup, getShard, setShard, takeGroup }

class MessageModel extends Serializable {
  static const currentVersion = 1;
  static const typeId = 10;

  static MessageModel? tryFromBase64(String? value) {
    if (value == null) return null;
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
    required this.peerId,
    DateTime? timestamp,
    required this.code,
    this.status = MessageStatus.created,
    this.payload,
  })  : id = id ?? MessageId(),
        timestamp = timestamp ?? DateTime.now(),
        payloadTypeId = type2TypeId[payload.runtimeType];

  @override
  bool operator ==(Object other) =>
      other is MessageModel &&
      runtimeType == other.runtimeType &&
      id.hashCode == other.id.hashCode;

  @override
  int get hashCode => Object.hash(runtimeType, id.hashCode);

  @override
  bool get isEmpty => payload == null;

  String get aKey => id.asKey;

  bool get haveVault => payload is VaultModel;
  VaultModel get vault => payload as VaultModel;

  bool get haveSecretShard => payload is SecretShardModel;
  SecretShardModel get secretShard => payload as SecretShardModel;

  PeerId get ownerId {
    switch (payload.runtimeType) {
      case SecretShardModel:
        return (payload as SecretShardModel).ownerId;
      case VaultModel:
        return (payload as VaultModel).ownerId;
      default:
        throw const FormatException('Payload have no ownerId!');
    }
  }

  VaultId get vaultId {
    switch (payload.runtimeType) {
      case SecretShardModel:
        return (payload as SecretShardModel).vaultId;
      case VaultModel:
        return (payload as VaultModel).id;
      default:
        throw const FormatException('Payload have no groupId!');
    }
  }

  bool get isRequested => status == MessageStatus.created;
  bool get isNotRequested => status != MessageStatus.created;

  bool get isReceived => status == MessageStatus.received;
  bool get isNotReceived => status != MessageStatus.received;

  bool get isAccepted => status == MessageStatus.accepted;
  bool get isRejected => status == MessageStatus.rejected;
  bool get isFailed => status == MessageStatus.failed;
  bool get isDuplicated => status == MessageStatus.duplicated;

  bool get isResolved =>
      status == MessageStatus.accepted || status == MessageStatus.rejected;

  bool get isNotResolved => !isResolved;

  bool get hasResponse =>
      status != MessageStatus.created && status != MessageStatus.received;

  bool get hasNoResponse => !hasResponse;

  factory MessageModel.fromBase64(String value) =>
      MessageModel.fromBytes(base64Decode(value));

  factory MessageModel.fromBytes(List<int> value) {
    final u = Unpacker(value is Uint8List ? value : Uint8List.fromList(value));
    final version = u.unpackInt()!;
    switch (version) {
      case 1:
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

  @override
  String toString() => '$id: $code, $status, typeId: $payloadTypeId';

  MessageModel copyWith({
    PeerId? peerId,
    MessageStatus? status,
    Serializable? payload,
    bool? emptyPayload,
  }) =>
      MessageModel(
        version: version,
        id: id,
        code: code,
        timestamp: timestamp,
        peerId: peerId ?? this.peerId,
        status: status ?? this.status,
        payload: emptyPayload == true ? null : payload ?? this.payload,
      );
}

const typeId2Type = {
  SecretShardModel.typeId: SecretShardModel.fromBytes,
  VaultModel.typeId: VaultModel.fromBytes,
};

const type2TypeId = {
  SecretShardModel: SecretShardModel.typeId,
  VaultModel: VaultModel.typeId,
};
