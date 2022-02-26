import 'dart:math';
import 'dart:typed_data';

import 'package:p2plib/p2plib.dart';

class AuthToken extends RawToken {
  static const length = 32;
  static final random = Random.secure();

  const AuthToken(Uint8List data) : super(data: data, len: length);

  factory AuthToken.generate() {
    final listInt = Iterable.generate(length, (x) => random.nextInt(255))
        .toList(growable: false);
    return AuthToken(Uint8List.fromList(listInt));
  }
}
