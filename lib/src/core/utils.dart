import 'dart:math';
import 'dart:typed_data';

const _chars = '0123456789ABCDEF';
final _random = Random.secure();

String getRandomString([int length = 64]) =>
    String.fromCharCodes(Iterable.generate(
        length, (_) => _chars.codeUnitAt(_random.nextInt(_chars.length))));

Uint8List getRandomBytes([int length = 32]) => Uint8List.fromList(
    Iterable.generate(length, (x) => _random.nextInt(255)).toList());

String toHex(Uint8List bytes) {
  final buffer = StringBuffer();
  for (int byte in bytes) {
    buffer.write('${byte < 16 ? '0' : ''}${byte.toRadixString(16)}');
  }
  return buffer.toString();
}

String toHexShort(Uint8List bytes, [int count = 12]) {
  final s = toHex(bytes);
  return s.length > count * 2
      ? '0x${s.substring(0, count)}...${s.substring(s.length - count)}'
      : '0x$s';
}
