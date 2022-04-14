import 'dart:typed_data' show Uint8List;
import 'dart:convert' show base64Decode, base64Encode;
import 'package:flutter/foundation.dart' show immutable;
import 'package:p2plib/p2plib.dart' show PubKey;
import 'package:cbor/cbor.dart';

enum RecoveryGroupType { devices, fiduciaries }

enum MessageStatus { request, success, reject }

enum MessageType { none, authPeer, getShard, setShard, takeOwnership }

@immutable
class P2PPacket {
  final MessageType type;
  final MessageStatus status;
  final Uint8List body;
  final PubKey? peerPubKey;

  const P2PPacket({
    this.type = MessageType.none,
    this.status = MessageStatus.request,
    required this.body,
    this.peerPubKey,
  });

  factory P2PPacket.emptyBody({
    MessageType type = MessageType.none,
    MessageStatus status = MessageStatus.request,
    PubKey? peerPubKey,
  }) =>
      P2PPacket(
        type: type,
        status: status,
        body: Uint8List(0),
        peerPubKey: peerPubKey,
      );

  factory P2PPacket.fromCbor(
    Uint8List value, [
    PubKey? peerPubKey,
  ]) {
    final packet = cbor.decode(value).toObject() as Map;
    return P2PPacket(
      type: MessageType.values[packet[0]],
      status: MessageStatus.values[packet[1]],
      body: Uint8List.fromList(packet[2]),
      peerPubKey: peerPubKey,
    );
  }

  Uint8List toCbor() => Uint8List.fromList(cbor.encode(CborMap({
        const CborSmallInt(0): CborSmallInt(type.index),
        const CborSmallInt(1): CborSmallInt(status.index),
        const CborSmallInt(2): CborBytes(body),
      })));
}

@immutable
class SecretShardPacket {
  final String ownerName;
  final String groupName;
  final int groupSize;
  final int groupThreshold;
  final Uint8List groupId;
  final Uint8List secretShard;

  const SecretShardPacket({
    required this.ownerName,
    required this.groupName,
    required this.groupSize,
    required this.groupThreshold,
    required this.groupId,
    required this.secretShard,
  });

  factory SecretShardPacket.fromCbor(Uint8List value) {
    final packet = cbor.decode(value).toObject() as Map;
    return SecretShardPacket(
      ownerName: packet[0],
      groupName: packet[1],
      groupSize: packet[2],
      groupThreshold: packet[3],
      groupId: Uint8List.fromList(packet[4]),
      secretShard: Uint8List.fromList(packet[5]),
    );
  }

  Uint8List toCbor() => Uint8List.fromList(cbor.encode(CborMap({
        const CborSmallInt(0): CborString(ownerName),
        const CborSmallInt(1): CborString(groupName),
        const CborSmallInt(2): CborSmallInt(groupSize),
        const CborSmallInt(3): CborSmallInt(groupThreshold),
        const CborSmallInt(4): CborBytes(groupId),
        const CborSmallInt(5): CborBytes(secretShard),
      })));
}

@immutable
class QRCode {
  final int version;
  final Uint8List authToken;
  final Uint8List pubKey;
  final Uint8List signPubKey;
  final Uint8List address;
  final String peerName;
  final MessageType type;

  const QRCode({
    this.version = 1,
    required this.authToken,
    required this.pubKey,
    required this.signPubKey,
    required this.address,
    required this.type,
    this.peerName = '',
  });

  factory QRCode.fromBase64(String qrCode) {
    final packet = cbor.decode(base64Decode(qrCode)).toObject() as Map;
    return QRCode(
      version: packet[0] as int,
      authToken: Uint8List.fromList(packet[1]),
      pubKey: Uint8List.fromList(packet[2]),
      signPubKey: Uint8List.fromList(packet[3]),
      address: Uint8List.fromList(packet[4]),
      peerName: packet[5],
      type: MessageType.values[packet[6]],
    );
  }

  @override
  String toString() => base64Encode(Uint8List.fromList(cborEncode(CborMap({
        const CborSmallInt(0): CborSmallInt(version),
        const CborSmallInt(1): CborBytes(authToken),
        const CborSmallInt(2): CborBytes(pubKey),
        const CborSmallInt(3): CborBytes(signPubKey),
        const CborSmallInt(4): CborBytes(address),
        const CborSmallInt(5): CborString(peerName),
        const CborSmallInt(6): CborSmallInt(type.index),
      }))));
}
