import 'dart:typed_data';

import 'package:guardian_keyper/data/repositories/settings_repository.dart';

export 'package:get_it/get_it.dart';

class WalletManager {
  final _settingsRepository = GetIt.I<SettingsRepository>();

  bool _hasEntropy = false;

  bool get hasEntropy => _hasEntropy;

  bool get hasNoEntropy => !_hasEntropy;

  Future<WalletManager> init() async {
    final entropy =
        _settingsRepository.get<Uint8List>(PreferencesKeys.keyEntropy);
    if (entropy != null) _hasEntropy = true;
    return this;
  }

  Future<void> close() async {}
}
