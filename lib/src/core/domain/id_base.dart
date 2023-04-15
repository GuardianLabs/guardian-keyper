part of 'core_model.dart';

abstract class IdBase extends Serializable {
  static const _listEq = ListEquality<int>();

  static final _random = Random.secure();

  static Uint8List getNew({int length = 8}) =>
      Uint8List.fromList(Iterable.generate(
        length,
        (x) => _random.nextInt(255),
      ).toList());

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
