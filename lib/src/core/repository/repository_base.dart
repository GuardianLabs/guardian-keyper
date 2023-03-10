import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

typedef KVStorage = FlutterSecureStorage;

abstract class RepositoryBase {
  const RepositoryBase();

  KVStorage get storage;

  static KVStorage getStorage(final String storageName) => FlutterSecureStorage(
        aOptions: AndroidOptions(
          encryptedSharedPreferences: true,
          sharedPreferencesName: storageName,
          preferencesKeyPrefix: 'guardian_keyper',
          storageCipherAlgorithm: StorageCipherAlgorithm.AES_GCM_NoPadding,
          keyCipherAlgorithm:
              KeyCipherAlgorithm.RSA_ECB_OAEPwithSHA_256andMGF1Padding,
        ),
      );

  Future<T> get<T extends Object>(final String key) async {
    final value = await storage.read(key: key) ?? '';
    switch (T) {
      case bool:
        return (value == 'true') as T;
      case String:
        return value as T;
      case Uint8List:
        return base64Decode(await storage.read(key: key) ?? '') as T;
      default:
        throw const FormatException('Unsupported type');
    }
  }

  Future<T> set<T extends Object>(final String key, final T value) async {
    switch (T) {
      case bool:
        await storage.write(
          key: key,
          value: value == true ? 'true' : 'false',
        );
        break;
      case String:
        await storage.write(
          key: key,
          value: value as String,
        );
        break;
      case Uint8List:
        await storage.write(
          key: key,
          value: base64UrlEncode(value as Uint8List),
        );
        break;
      default:
        throw const FormatException('Unsupported type');
    }
    return value;
  }

  Future<String> delete(final String key) async {
    await storage.delete(key: key);
    return key;
  }
}
