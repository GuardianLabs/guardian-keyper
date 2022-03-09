import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:p2plib/p2plib.dart';

enum KeeperMsgType { authResult, setShardResult, getShardResult }

@immutable
class KeeperBody {
  final KeeperMsgType msgType;
  final Uint8List data;

  static const minimalLength = 2;

  const KeeperBody(this.msgType, this.data);

  factory KeeperBody.createAuthStatus(ProcessStatus status) {
    return KeeperBody.createStatusMsg(KeeperMsgType.authResult, status);
  }

  factory KeeperBody.createSaveDataStatus(ProcessStatus status) {
    return KeeperBody.createStatusMsg(KeeperMsgType.setShardResult, status);
  }

  factory KeeperBody.createData(Uint8List data) {
    return KeeperBody(KeeperMsgType.getShardResult, data);
  }

  factory KeeperBody.createStatusMsg(KeeperMsgType type, ProcessStatus status) {
    ByteData bytes = ByteData(1);
    bytes.setUint8(0, status.index);
    return KeeperBody(type, bytes.buffer.asUint8List());
  }

  Uint8List serialize() {
    ByteData bytes = ByteData(1 + data.length);
    int offset = 0;
    bytes.setUint8(offset++, msgType.index);
    for (var byte in data) {
      bytes.setInt8(offset++, byte);
    }
    return bytes.buffer.asUint8List();
  }

  factory KeeperBody.deserialize(Uint8List data) {
    final bytes = ByteData.view(data.buffer);
    if (bytes.lengthInBytes < 1) {
      throw IncorrectPacketLength('KeeperBodyPacket');
    }
    final type = KeeperMsgType.values[bytes.getUint8(0)];
    final bodyData = data.sublist(1);

    return KeeperBody(type, bodyData);
  }
}

@immutable
class KeeperPacket {
  final Header header;
  final Uint8List body;

  const KeeperPacket(this.header, this.body);

  factory KeeperPacket.deserialize(Uint8List data) {
    const minimalLength = Header.length + KeeperBody.minimalLength;

    final bytes = ByteData.view(data.buffer);
    if (bytes.lengthInBytes < minimalLength) {
      throw IncorrectPacketLength('KeeperPacket');
    }

    final header = Header.deserialize(data.sublist(0, Header.length));
    final body = data.sublist(Header.length);
    return KeeperPacket(header, body);
  }

  Uint8List serialize() {
    final builder = BytesBuilder();
    builder.add(header.serialize());
    builder.add(body);
    return builder.toBytes();
  }
}
