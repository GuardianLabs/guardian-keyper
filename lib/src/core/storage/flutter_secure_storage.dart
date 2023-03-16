import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as fss;

import 'secure_storage.dart';

export 'secure_storage.dart';

class FlutterSecureStorage implements SecureStorage {
  static final Map<String, FlutterSecureStorage> _cache = {};

  FlutterSecureStorage._(this._storage);

  factory FlutterSecureStorage({required final String storageName}) =>
      _cache.putIfAbsent(
        storageName,
        () => FlutterSecureStorage._(fss.FlutterSecureStorage(
          aOptions: fss.AndroidOptions(
            encryptedSharedPreferences: true,
            sharedPreferencesName: storageName,
            preferencesKeyPrefix: 'guardian_keyper',
            storageCipherAlgorithm:
                fss.StorageCipherAlgorithm.AES_GCM_NoPadding,
            keyCipherAlgorithm:
                fss.KeyCipherAlgorithm.RSA_ECB_OAEPwithSHA_256andMGF1Padding,
          ),
          iOptions: fss.IOSOptions(accountName: storageName),
        )),
      );

  final fss.FlutterSecureStorage _storage;

  @override
  Future<T?> get<T extends Object>(final String key) async {
    final value = await _storage.read(key: key);
    if (value == null) return null;
    switch (T) {
      case bool:
        return (value == 't') as T;
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

  @override
  Future<T> getOr<T extends Object>(
    final String key,
    final T defaultValue,
  ) async =>
      (await get<T>(key)) ?? defaultValue;

  @override
  Future<void> set<T extends Object>(final String key, final T? value) async {
    if (value == null) return _storage.write(key: key, value: null);
    switch (T) {
      case bool:
        await _storage.write(key: key, value: value.toString());
        break;
      case String:
        await _storage.write(key: key, value: value as String);
        break;
      case int:
        await _storage.write(key: key, value: value.toString());
        break;
      case Uint8List:
        await _storage.write(
          key: key,
          value: base64UrlEncode(value as Uint8List),
        );
        break;
      default:
        throw const ValueFormatException();
    }
  }

  @override
  Future<void> delete(final String key) => _storage.delete(key: key);
}
