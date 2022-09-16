part of 'core_model.dart';

@immutable
abstract class TokenBase extends Equatable {
  final Uint8List value;

  @override
  List<Object> get props => [value];

  const TokenBase({required this.value});

  bool get isEmpty => value.isEmpty;

  bool get isNotEmpty => value.isNotEmpty;

  int get length => value.length;

  String get asKey => base64UrlEncode(value);

  String get asHex {
    final buffer = StringBuffer();
    for (int byte in value) {
      buffer.write('${byte < 16 ? '0' : ''}${byte.toRadixString(16)}');
    }
    return buffer.toString();
  }

  String toHexShort([int count = 12]) {
    final s = asHex;
    return s.length > count * 2
        ? '0x${s.substring(0, count)}...${s.substring(s.length - count)}'
        : '0x$s';
  }
}

@immutable
class PeerId extends TokenBase {
  const PeerId({required super.value})
      : assert(value.length == 0 || value.length == 64);

  factory PeerId.empty() => PeerId(value: Uint8List(0));
}

@immutable
class GroupId extends TokenBase {
  static const _length = 8;

  const GroupId({required super.value})
      : assert(value.length == 0 || value.length == _length);

  factory GroupId.aNew() => GroupId(value: getRandomBytes(_length));

  factory GroupId.empty() => GroupId(value: Uint8List(0));
}

@immutable
class SecretId extends TokenBase {
  static const _length = 8;

  const SecretId({required super.value})
      : assert(value.length == 0 || value.length == _length);

  factory SecretId.aNew() => SecretId(value: getRandomBytes(_length));

  factory SecretId.empty() => SecretId(value: Uint8List(0));
}

@immutable
class Nonce extends TokenBase {
  const Nonce({required super.value});

  factory Nonce.aNew([length = 32]) => Nonce(value: getRandomBytes(length));

  factory Nonce.empty() => Nonce(value: Uint8List(0));
}
