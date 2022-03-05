import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:p2plib/p2plib.dart';

enum OwnerMsgType { setShard, getShard, authPeer }

@immutable
class OwnerBody {
  final OwnerMsgType type;
  final Uint8List data;

  static const minimalLength = 1;

  const OwnerBody(this.type, this.data);

  Uint8List serialize() {
    ByteData bytes = ByteData(1 + data.length);
    int offset = 0;
    bytes.setUint8(offset++, type.index);
    for (var byte in data) {
      bytes.setInt8(offset++, byte);
    }
    return bytes.buffer.asUint8List();
  }

  factory OwnerBody.deserialize(Uint8List data) {
    final bytes = ByteData.view(data.buffer);
    if (bytes.lengthInBytes < 1) {
      throw IncorrectPacketLength('OwnerBodyPacket');
    }
    final type = OwnerMsgType.values[bytes.getUint8(0)];
    final bodyData = data.sublist(1);

    return OwnerBody(type, bodyData);
  }
}

@immutable
class OwnerPacket {
  final Header header;
  final Uint8List body;

  const OwnerPacket(this.header, this.body);

  factory OwnerPacket.deserialize(Uint8List data) {
    const minimalLength = Header.length + OwnerBody.minimalLength;

    if (data.length < minimalLength) {
      throw IncorrectPacketLength('OwnerPacket');
    }

    final header = Header.deserialize(data.sublist(0, Header.length));
    final body = data.sublist(Header.length);
    return OwnerPacket(header, body);
  }

  Uint8List serialize() {
    final builder = BytesBuilder();
    builder.add(header.serialize());
    builder.add(body);
    return builder.toBytes();
  }
}
