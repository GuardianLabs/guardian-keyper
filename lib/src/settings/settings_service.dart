import 'package:p2plib/p2plib.dart' as p2p;
import 'package:sodium/sodium.dart' show KeyPair;

import '../core/service/kv_storage.dart';
import 'settings_model.dart';

class SettingsService {
  static const _keyPairPath = 'key_pair';
  static const _settingsPath = 'settings';

  final KVStorage storage;
  final String deviceName;

  const SettingsService({
    required this.storage,
    required this.deviceName,
  });

  Future<SettingsModel> load() async {
    final settings = await storage.read(key: _settingsPath);
    return settings == null
        ? SettingsModel(deviceName: deviceName, pinCode: '') // Defaults
        : SettingsModel.fromJson(settings);
  }

  Future<void> save(SettingsModel settings) async =>
      await storage.write(key: _settingsPath, value: settings.toJson());

  Future<KeyPairModel> getKeyPair() async {
    final keyPairString = await storage.read(key: _keyPairPath);

    if (keyPairString == null) {
      final keyPair = p2p.P2PCrypto().sodium.crypto.box.keyPair() as KeyPair;

      final keyPairModel = KeyPairModel(
        privateKey: keyPair.secretKey.extractBytes(),
        publicKey: keyPair.publicKey,
      );
      await storage.write(
        key: _keyPairPath,
        value: KeyPairModel.toJson(keyPairModel),
      );
      return keyPairModel;
    }
    return KeyPairModel.fromJson(keyPairString);
  }
}
