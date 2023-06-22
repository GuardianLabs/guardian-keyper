import 'package:flutter_test/flutter_test.dart';
import '../data/filled_models.dart';

void main() {
  test(
      'Nonce '
      'should be: A equal AA and not equal B', () {
    expect(tokenA == tokenAA, true);
    expect(tokenA == tokenB, false);
  });
}
