import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:messagepack/messagepack.dart';

import 'package:guardian_keyper/domain/entity/serializable.dart';
import 'package:guardian_keyper/feature/network/domain/entity/peer_id.dart';
import 'package:guardian_keyper/feature/vault/domain/entity/secret_shard.dart';
import 'package:guardian_keyper/feature/vault/domain/entity/vault_id.dart';
import 'package:guardian_keyper/feature/vault/domain/entity/vault.dart';

import 'message_id.dart';

enum MessageStatus {
  created,
  received,
  accepted,
  rejected,
  failed,
  duplicated,
}

enum MessageCode { createVault, getShard, setShard, takeVault }

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

  MessageModel({
    this.version = currentVersion,
    MessageId? id,
    DateTime? timestamp,
    required this.peerId,
    required this.code,
    this.status = MessageStatus.created,
    this.payload,
  })  : id = id ?? MessageId(),
        timestamp = timestamp ?? DateTime.timestamp();

  final int version;
  final MessageId id;
  final PeerId peerId;
  final DateTime timestamp;
  final MessageCode code;
  final MessageStatus status;
  final Serializable? payload;

  late final String aKey = id.asKey;

  late final int? payloadTypeId = payload == null
      ? null
      : switch (payload.runtimeType) {
          const (Vault) => Vault.typeId,
          const (SecretShard) => SecretShard.typeId,
          _ => throw const FormatException('Unsupported payload type!'),
        };

  @override
  bool operator ==(Object other) =>
      other is MessageModel &&
      runtimeType == other.runtimeType &&
      id.hashCode == other.id.hashCode;

  @override
  int get hashCode => Object.hash(runtimeType, id.hashCode);

  bool get containsVault => payload is Vault;
  Vault get vault => payload as Vault;

  bool get containsSecretShard => payload is SecretShard;
  SecretShard get secretShard => payload as SecretShard;

  PeerId get ownerId => switch (payload) {
        Vault vault => vault.ownerId,
        SecretShard shard => shard.ownerId,
        _ => throw const FormatException('Payload have no ownerId!'),
      };

  VaultId get vaultId => switch (payload) {
        Vault vault => vault.id,
        SecretShard shard => shard.vaultId,
        _ => throw const FormatException('Payload have no vaultId!'),
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
    final version = u.unpackInt();
    return switch (version) {
      currentVersion => MessageModel(
          version: version!,
          id: MessageId.fromBytes(u.unpackBinary()),
          peerId: PeerId.fromBytes(u.unpackBinary()),
          timestamp: DateTime.fromMillisecondsSinceEpoch(
            u.unpackInt()!,
            isUtc: true,
          ),
          code: MessageCode.values[u.unpackInt()!],
          status: MessageStatus.values[u.unpackInt()!],
          payload: switch (u.unpackInt()) {
            null => null,
            Vault.typeId => Vault.fromBytes(u.unpackBinary()),
            SecretShard.typeId => SecretShard.fromBytes(u.unpackBinary()),
            _ => throw const FormatException('Unsupported payload type!'),
          },
        ),
      _ => throw const FormatException('Unsupported version of Message!'),
    };
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
