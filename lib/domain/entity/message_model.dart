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
  static const requestExpires = Duration(days: 1);

  static MessageModel? tryFromBase64(String? value) {
    try {
      return MessageModel.fromBase64(value!);
    } catch (_) {
      return null;
    }
  }

  static MessageModel? tryFromBytes(Uint8List? value) {
    try {
      return MessageModel.fromBytes(value!);
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
    DateTime? timestamp,
    required this.peerId,
    required this.code,
    this.status = MessageStatus.created,
    this.payload,
  })  : id = id ?? MessageId(),
        timestamp = timestamp ?? DateTime.timestamp(),
        payloadTypeId = switch (payload) {
          VaultModel _ => VaultModel.typeId,
          SecretShardModel _ => SecretShardModel.typeId,
          _ => throw const FormatException('Unsupported payload type!'),
        };

  @override
  bool operator ==(Object other) =>
      other is MessageModel &&
      runtimeType == other.runtimeType &&
      id.hashCode == other.id.hashCode;

  @override
  int get hashCode => Object.hash(runtimeType, id.hashCode);

  String get aKey => id.asKey;

  bool get haveVault => payload is VaultModel;
  VaultModel get vault => payload as VaultModel;

  bool get haveSecretShard => payload is SecretShardModel;
  SecretShardModel get secretShard => payload as SecretShardModel;

  PeerId get ownerId => switch (payload) {
        VaultModel vault => vault.ownerId,
        SecretShardModel shard => shard.ownerId,
        _ => throw const FormatException('Payload have no ownerId!'),
      };

  VaultId get vaultId => switch (payload) {
        VaultModel vault => vault.id,
        SecretShardModel shard => shard.vaultId,
        _ => throw const FormatException('Payload have no groupId!'),
      };

  bool get isNotRequested => status != MessageStatus.created;

  bool get isReceived => status == MessageStatus.received;
  bool get isNotReceived => status != MessageStatus.received;

  bool get isAccepted => status == MessageStatus.accepted;
  bool get isRejected => status == MessageStatus.rejected;

  bool get hasResponse =>
      status != MessageStatus.created && status != MessageStatus.received;

  bool get hasNoResponse => !hasResponse;

  bool get isExpired =>
      timestamp.isBefore(DateTime.timestamp().subtract(requestExpires));

  bool get isForPrune =>
      (status == MessageStatus.created || status == MessageStatus.received) &&
      isExpired;

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
        final payload = switch (payloadTypeId) {
          VaultModel.typeId => VaultModel.fromBytes(payloadRaw),
          SecretShardModel.typeId => SecretShardModel.fromBytes(payloadRaw),
          _ => throw const FormatException('Unsupported payload type!'),
        };
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
