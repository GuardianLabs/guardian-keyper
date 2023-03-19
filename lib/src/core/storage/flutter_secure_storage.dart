import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as fss;

import 'secure_storage.dart';

export 'secure_storage.dart';

class FlutterSecureStorage implements SecureStorage {
  static final Map<String, FlutterSecureStorage> _cache = {};

  FlutterSecureStorage._(this._storage);

  factory FlutterSecureStorage({required final Storages storage}) =>
      _cache.putIfAbsent(
        storage.name,
        () => FlutterSecureStorage._(fss.FlutterSecureStorage(
          aOptions: fss.AndroidOptions(
            encryptedSharedPreferences: true,
            sharedPreferencesName: storage.name,
            preferencesKeyPrefix: 'guardian_keyper',
            storageCipherAlgorithm:
                fss.StorageCipherAlgorithm.AES_GCM_NoPadding,
            keyCipherAlgorithm:
                fss.KeyCipherAlgorithm.RSA_ECB_OAEPwithSHA_256andMGF1Padding,
          ),
          iOptions: fss.IOSOptions(accountName: storage.name),
        )),
      );

  final fss.FlutterSecureStorage _storage;

  @override
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

  @override
  Future<T> getOr<T extends Object>(
    final Object key,
    final T defaultValue,
  ) async =>
      (await get<T>(key)) ?? defaultValue;

  @override
  Future<T?> set<T extends Object>(final Object key, final T? value) async {
    switch (T) {
      case Null:
        await _storage.write(key: key.toString(), value: null);
        break;
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

  @override
  Future<Object> delete(final Object key) async {
    await _storage.delete(key: key.toString());
    return key;
  }
}
