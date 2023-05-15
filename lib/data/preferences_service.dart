import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const keySeed = 'seed';
const keyPassCode = 'passCode';
const keyDeviceName = 'deviceName';
const keyIsBootstrapEnabled = 'isBootstrapEnabled';
const keyIsBiometricsEnabled = 'isBiometricsEnabled';

class PreferencesService {
  static const _storageName = 'settings';
  static const _storage = FlutterSecureStorage(
    iOptions: IOSOptions(accountName: _storageName),
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
      sharedPreferencesName: _storageName,
      storageCipherAlgorithm: StorageCipherAlgorithm.AES_GCM_NoPadding,
      keyCipherAlgorithm:
          KeyCipherAlgorithm.RSA_ECB_OAEPwithSHA_256andMGF1Padding,
    ),
  );

  Future<T?> get<T extends Object>(String key) =>
      _storage.read(key: key).then((value) => value == null
          ? null
          : switch (T) {
              String => value as T,
              bool => bool.tryParse(value) as T,
              Uint8List => base64Decode(value) as T,
              _ => throw const ValueFormatException(),
            });

  Future<void> set<T extends Object>(String key, T value) => switch (T) {
        bool || String => _storage.write(key: key, value: value.toString()),
        Uint8List => _storage.write(
            key: key,
            value: base64UrlEncode(value as Uint8List),
          ),
        _ => throw const ValueFormatException(),
      };
}

class ValueFormatException extends FormatException {
  const ValueFormatException() : super('Unsupported value type');
}