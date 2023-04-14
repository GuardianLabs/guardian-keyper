import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:collection/collection.dart';
import 'package:messagepack/messagepack.dart';

import '/src/core/consts.dart';

export '/src/vaults/data/vault_model.dart';
export '/src/vaults/data/secret_shard_model.dart';
export '/src/message/data/message_model.dart';

part 'peer_id.dart';

abstract class Serializable {
  const Serializable();

  bool get isEmpty;

  bool get isNotEmpty;

  Uint8List toBytes();

  String toBase64url() => base64UrlEncode(toBytes());
}

abstract class IdBase extends Serializable {
  static const _listEq = ListEquality<int>();

  static const minNameLength = minTokenNameLength;
  static const maxNameLength = maxTokenNameLength;

  final String name;
  final Uint8List token;

  const IdBase({required this.token, this.name = ''});

  @override
  int get hashCode => Object.hash(runtimeType, _listEq.hash(token));

  @override
  bool operator ==(Object other) =>
      other is IdBase &&
      runtimeType == other.runtimeType &&
      _listEq.equals(token, other.token);

  @override
  bool get isEmpty => token.isEmpty;

  @override
  bool get isNotEmpty => token.isNotEmpty;

  int get tokenEmojiByte => token.fold(0, (v, e) => v ^ e);

  String get asKey => base64UrlEncode(token);

  String get asHex {
    final buffer = StringBuffer();
    for (final byte in token) {
      buffer.write(byte.toRadixString(16).padLeft(2, '0'));
    }
    return buffer.toString();
  }

  @override
  Uint8List toBytes() => token;

  @override
  String toString() => asHex;

  String toHexShort([int count = 12]) {
    final s = asHex;
    return s.length > count * 2
        ? '0x${s.substring(0, count)}...${s.substring(s.length - count)}'
        : '0x$s';
  }
}

class PeerAddress {
  static const _listEq = ListEquality<int>();

  final InternetAddress address;
  final int port;

  const PeerAddress({required this.address, required this.port});

  @override
  int get hashCode =>
      Object.hash(runtimeType, port, _listEq.hash(address.rawAddress));

  @override
  bool operator ==(Object other) =>
      other is PeerAddress &&
      runtimeType == other.runtimeType &&
      port == other.port &&
      _listEq.equals(address.rawAddress, other.address.rawAddress);

  bool get isIPv4 => address.type == InternetAddressType.IPv4;

  bool get isIPv6 => address.type == InternetAddressType.IPv6;
}
