import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum Storages { settings }

class SecureStorage {
  static final Map<String, SecureStorage> _cache = {};

  SecureStorage._(this._storage);

  factory SecureStorage({required final Storages storage}) =>
      _cache.putIfAbsent(
        storage.name,
        () => SecureStorage._(FlutterSecureStorage(
          aOptions: AndroidOptions(
            encryptedSharedPreferences: true,
            sharedPreferencesName: storage.name,
            preferencesKeyPrefix: 'guardian_keyper',
            storageCipherAlgorithm: StorageCipherAlgorithm.AES_GCM_NoPadding,
            keyCipherAlgorithm:
                KeyCipherAlgorithm.RSA_ECB_OAEPwithSHA_256andMGF1Padding,
          ),
          iOptions: IOSOptions(accountName: storage.name),
        )),
      );

  final FlutterSecureStorage _storage;

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

  Future<Object> delete(final Object key) async {
    await _storage.delete(key: key.toString());
    return key;
  }
}

class ValueFormatException extends FormatException {
  const ValueFormatException() : super('Unsupported value type');
}
