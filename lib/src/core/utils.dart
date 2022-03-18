import 'dart:math';
import 'dart:typed_data';

const _chars = '0123456789ABCDEF';
final _random = Random.secure();

String getRandomString([int length = 64]) =>
    String.fromCharCodes(Iterable.generate(
        length, (_) => _chars.codeUnitAt(_random.nextInt(_chars.length))));

Uint8List getRandomBytes([int length = 32]) => Uint8List.fromList(
    Iterable.generate(length, (x) => _random.nextInt(255)).toList());
