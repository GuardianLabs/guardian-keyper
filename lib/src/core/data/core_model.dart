import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:equatable/equatable.dart';
import 'package:messagepack/messagepack.dart';

import '/src/core/consts.dart';

export '/src/vaults/data/vault_model.dart';
export '/src/vaults/data/secret_shard_model.dart';
export '/src/message/data/message_model.dart';

part 'peer_id.dart';

abstract class Serializable extends Equatable {
  const Serializable();

  bool get isEmpty;

  bool get isNotEmpty;

  Uint8List toBytes();

  String toBase64url() => base64UrlEncode(toBytes());
}

abstract class IdBase extends Serializable {
  final Uint8List token;

  const IdBase({required this.token});

  @override
  List<Object> get props => [token];

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

abstract class IdWithNameBase extends IdBase {
  static const minNameLength = 3;
  static const maxNameLength = 25;

  final String name;

  const IdWithNameBase({required super.token, this.name = ''});

  String get emoji;
}

class PeerAddress extends Equatable {
  final InternetAddress address;
  final int port;

  const PeerAddress({required this.address, required this.port});

  @override
  List<Object> get props => [address, port];

  bool get isIPv4 => address.type == InternetAddressType.IPv4;

  bool get isIPv6 => address.type == InternetAddressType.IPv6;
}
