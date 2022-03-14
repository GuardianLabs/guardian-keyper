import 'dart:typed_data' show Uint8List;
import 'dart:convert' show base64Decode, base64Encode;
import 'package:flutter/foundation.dart' show immutable;
import 'package:p2plib/p2plib.dart' as p2p show Header, RawToken, PubKey;
import 'package:cbor/cbor.dart';

typedef PubKey = p2p.PubKey;

typedef AuthToken = p2p.PubKey;

typedef RawToken = p2p.RawToken;

enum MessageType { none, authPeer, getShard, setShard }

enum MessageStatus { none, success, reject }

@immutable
class P2PPacket {
  final p2p.Header header;
  final MessageType type;
  final MessageStatus status;
  final Uint8List body;

  const P2PPacket({
    required this.header,
    this.type = MessageType.none,
    this.status = MessageStatus.none,
    required this.body,
  });

  factory P2PPacket.emptyBody({
    required p2p.Header header,
    MessageType type = MessageType.none,
    MessageStatus status = MessageStatus.none,
  }) =>
      P2PPacket(header: header, body: Uint8List(0));

  factory P2PPacket.fromCbor(Uint8List value) {
    final packet = cbor.decode(value).toObject() as Map;
    return P2PPacket(
      header: p2p.Header.deserialize(Uint8List.fromList(packet[0])),
      type: MessageType.values[packet[1]],
      body: Uint8List.fromList(packet[2]),
    );
  }

  Uint8List toCbor() => Uint8List.fromList(cbor.encode(CborMap({
        const CborSimpleValue(0): CborBytes(header.serialize()),
        const CborSimpleValue(1): CborSimpleValue(type.index),
        const CborSimpleValue(2): CborBytes(body),
      })));
}

@immutable
class SetShardPacket {
  final Uint8List groupId;
  final Uint8List secretShard;

  const SetShardPacket({required this.groupId, required this.secretShard});

  factory SetShardPacket.fromCbor(Uint8List value) {
    final packet = cbor.decode(value).toObject() as Map;
    return SetShardPacket(
      groupId: Uint8List.fromList(packet[0]),
      secretShard: Uint8List.fromList(packet[1]),
    );
  }

  Uint8List toCbor() => Uint8List.fromList(cbor.encode(CborMap({
        const CborSimpleValue(0): CborBytes(groupId),
        const CborSimpleValue(1): CborBytes(secretShard),
      })));
}

@immutable
class QRCode {
  final int version;
  final Uint8List authToken;
  final Uint8List pubKey;
  final Uint8List signPubKey;

  const QRCode({
    this.version = 1,
    required this.authToken,
    required this.pubKey,
    required this.signPubKey,
  });

  factory QRCode.fromBase64(String qrCode) {
    final packet = cbor.decode(base64Decode(qrCode)).toObject() as Map;
    return QRCode(
      version: packet[0] as int,
      authToken: Uint8List.fromList(packet[1]),
      pubKey: Uint8List.fromList(packet[2]),
      signPubKey: Uint8List.fromList(packet[3]),
    );
  }

  @override
  String toString() => base64Encode(Uint8List.fromList(cborEncode(CborMap({
        const CborSmallInt(0): CborSmallInt(version),
        const CborSmallInt(1): CborBytes(authToken),
        const CborSmallInt(2): CborBytes(pubKey),
        const CborSmallInt(3): CborBytes(signPubKey),
      }))));
}

enum RequestStatus { idle, recieved, sending, sent, timeout, error }

@immutable
class P2PPacketStream {
  final P2PPacket? p2pPacket;
  final RequestStatus? requestStatus;
  final Object? error;
  final Object? stackTrace;

  const P2PPacketStream({
    this.p2pPacket,
    this.requestStatus,
    this.error,
    this.stackTrace,
  });
}
