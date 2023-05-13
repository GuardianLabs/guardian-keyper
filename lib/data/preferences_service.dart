import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const keySeed = 'seed';
const keyPassCode = 'pass_code';
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

  const PreferencesService();

  Future<T?> get<T extends Object>(final Object key) async {
    final value = await _storage.read(key: key.toString());
    if (value == null) return null;
    switch (T) {
      case bool:
        return (value == 'true') as T;
      case String:
        return value as T;
      case int:
        return int.parse(value) as T;
      case Uint8List:
        return base64Decode(value) as T;
      default:
        throw const ValueFormatException();
    }
  }

  Future<T> set<T extends Object>(final Object key, final T value) async {
    switch (T) {
      case bool:
        await _storage.write(key: key.toString(), value: value.toString());
        break;
      case String:
        await _storage.write(key: key.toString(), value: value as String);
        break;
      case int:
        await _storage.write(key: key.toString(), value: value.toString());
        break;
      case Uint8List:
        await _storage.write(
          key: key.toString(),
          value: base64UrlEncode(value as Uint8List),
        );
        break;
      default:
        throw const ValueFormatException();
    }
    return value;
  }

  Future<Object> delete(final Object key) async {
    await _storage.delete(key: key.toString());
    return key;
  }
}

class ValueFormatException extends FormatException {
  const ValueFormatException() : super('Unsupported value type');
}
