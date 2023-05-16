import 'package:flutter/foundation.dart';
import 'package:sss256/sss256.dart' as sss;

/// Shamir`s secret sharing
mixin class VaultSssMixin {
  // TBD: use closure
  Future<String> restoreSecret(List<String> shares) =>
      compute<List<String>, String>(
        (List<String> shares) => sss.restoreSecret(shares: shares),
        shares,
      );

  // TBD: use closure
  Future<List<String>> splitSecret({
    required int shares,
    required int threshold,
    required String secret,
  }) async {
    final shards = await compute<({int shares, int threshold, String secret}),
        List<String>>(
      (params) => sss.splitSecret(
        treshold: params.threshold,
        shares: params.shares,
        secret: params.secret,
      ),
      (shares: shares, threshold: threshold, secret: secret),
    );
    if ((await restoreSecret(shards)) == secret) return shards;
    throw const FormatException('Can not split and restore the secret!');
  }
}
