part of 'core_model.dart';

abstract class IdBase extends Serializable {
  final Uint8List token;

  const IdBase({required this.token});

  @override
  List<Object> get props => [token];

  @override
  bool get isEmpty => token.isEmpty;

  @override
  bool get isNotEmpty => token.isNotEmpty;

  int get length => token.length;

  int get tokenByteHash => token.fold(0, (v, e) => v ^ e);

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

  const IdWithNameBase({required super.token, required this.name});

  String get emoji;
}

class PeerId extends IdWithNameBase {
  static const currentVersion = 1;
  static const size = 64;

  @override
  String get emoji => String.fromCharCode(emojiPeer[tokenByteHash]);

  // TBD: wtf?
  const PeerId._({required super.token, required super.name});

  factory PeerId({Uint8List? token, String name = ''}) {
    if (token == null || token.isEmpty || token.length == size) {
      return PeerId._(token: token ?? Uint8List(0), name: name);
    }
    throw const FormatException();
  }

  factory PeerId.fromBytes(List<int> token) {
    final u = Unpacker(token is Uint8List ? token : Uint8List.fromList(token));
    final version = u.unpackInt()!;
    if (version != currentVersion) throw const FormatException();
    return PeerId(
      token: Uint8List.fromList(u.unpackBinary()),
      name: u.unpackString()!,
    );
  }

  @override
  Uint8List toBytes() {
    final p = Packer()
      ..packInt(currentVersion)
      ..packBinary(token)
      ..packString(name);
    return p.takeBytes();
  }

  PeerId copyWith({String? name}) =>
      PeerId(token: token, name: name ?? this.name);
}

class GroupId extends IdWithNameBase {
  static const currentVersion = 1;
  static const size = 8;

  @override
  String get emoji => String.fromCharCode(emojiVault[tokenByteHash]);

  GroupId({Uint8List? token, super.name = ''})
      : super(token: token ?? getRandomBytes(size));

  factory GroupId.fromBytes(List<int> token) {
    final u = Unpacker(token is Uint8List ? token : Uint8List.fromList(token));
    final version = u.unpackInt()!;
    if (version != currentVersion) throw const FormatException();
    return GroupId(
      token: Uint8List.fromList(u.unpackBinary()),
      name: u.unpackString()!,
    );
  }

  @override
  Uint8List toBytes() {
    final p = Packer()
      ..packInt(currentVersion)
      ..packBinary(token)
      ..packString(name);
    return p.takeBytes();
  }

  GroupId copyWith({String? name}) => GroupId(
        token: token,
        name: name ?? this.name,
      );
}

class SecretId extends IdWithNameBase {
  static const currentVersion = 1;
  static const size = 8;

  @override
  String get emoji => String.fromCharCode(emojiSecret[tokenByteHash]);

  SecretId({Uint8List? token, required super.name})
      : super(token: token ?? getRandomBytes(size));

  factory SecretId.fromBytes(List<int> token) {
    final u = Unpacker(token is Uint8List ? token : Uint8List.fromList(token));
    final version = u.unpackInt()!;
    if (version != currentVersion) throw const FormatException();
    return SecretId(
      token: Uint8List.fromList(u.unpackBinary()),
      name: u.unpackString()!,
    );
  }

  @override
  Uint8List toBytes() {
    final p = Packer()
      ..packInt(currentVersion)
      ..packBinary(token)
      ..packString(name);
    return p.takeBytes();
  }

  SecretId copyWith({String? name}) => SecretId(
        token: token,
        name: name ?? this.name,
      );
}

class MessageId extends IdBase {
  static const currentVersion = 1;
  static const size = 16;

  MessageId({Uint8List? token}) : super(token: token ?? getRandomBytes(size));

  factory MessageId.fromBytes(List<int> token) {
    final u = Unpacker(token is Uint8List ? token : Uint8List.fromList(token));
    final version = u.unpackInt()!;
    if (version != currentVersion) throw const FormatException();
    return MessageId(token: Uint8List.fromList(u.unpackBinary()));
  }

  @override
  Uint8List toBytes() {
    final p = Packer()
      ..packInt(currentVersion)
      ..packBinary(token);
    return p.takeBytes();
  }
}
