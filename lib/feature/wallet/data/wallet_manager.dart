import 'dart:typed_data';
import 'package:get_it/get_it.dart';

import 'package:guardian_keyper/data/services/preferences_service.dart';

export 'package:get_it/get_it.dart';

class WalletManager {
  final _preferencesService = GetIt.I<PreferencesService>();

  bool _hasEntropy = false;

  bool get hasEntropy => _hasEntropy;

  bool get hasNoEntropy => !_hasEntropy;

  Future<WalletManager> init() async {
    final entropy =
        await _preferencesService.get<Uint8List>(PreferencesKeys.keyEntropy);
    if (entropy != null) _hasEntropy = true;
    return this;
  }

  Future<void> close() async {}
}
