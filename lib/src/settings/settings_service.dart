import 'package:flutter/material.dart';
import 'package:p2plib/p2plib.dart' as p2p;
import 'package:sodium/sodium.dart' show KeyPair;

import '../core/service/kv_storage.dart';
import 'settings_model.dart';

class SettingsService {
  static const _keyPairPath = 'key_pair';
  static const _settingsPath = 'settings';

  const SettingsService(this._storage);

  final KVStorage _storage;

  // void init() async {
  //   if (!await _storage.containsKey(key: 'settings')) {}

  // }

  Future<ThemeMode> themeMode() async => ThemeMode.dark;

  Future<void> updateThemeMode(ThemeMode theme) async {
    if (!await _storage.containsKey(key: _settingsPath)) {}
  }

  Future<KeyPairModel> getKeyPair() async {
    final keyPairString = await _storage.read(key: _keyPairPath);

    if (keyPairString == null) {
      final keyPair = p2p.P2PCrypto().sodium.crypto.box.keyPair() as KeyPair;

      final keyPairModel = KeyPairModel(
        privateKey: keyPair.secretKey.extractBytes(),
        publicKey: keyPair.publicKey,
      );
      await _storage.write(
        key: _keyPairPath,
        value: KeyPairModel.toJson(keyPairModel),
      );
      return keyPairModel;
    }
    return KeyPairModel.fromJson(keyPairString);
  }
}
