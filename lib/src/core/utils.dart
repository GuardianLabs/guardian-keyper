import 'dart:math';

const chars = '0123456789ABCDEF';
final random = Random();

String getRandomString([int length = 64]) =>
    String.fromCharCodes(Iterable.generate(
        length, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
