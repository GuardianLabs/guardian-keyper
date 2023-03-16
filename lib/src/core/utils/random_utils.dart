import 'dart:math' show Random;
import 'dart:typed_data' show Uint8List;

final _random = Random.secure();

Uint8List getRandomBytes([int length = 32]) =>
    Uint8List.fromList(Iterable.generate(
      length,
      (x) => _random.nextInt(255),
    ).toList());
