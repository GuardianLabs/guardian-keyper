import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum PreferencesKeys {
  keySeed,
  keyPassCode,
  keyLastStart,
  keyDeviceName,
  keyIsBootstrapEnabled,
  keyIsBiometricsEnabled,
}

class PreferencesService {
  static const _iOptions = IOSOptions(
    accessibility: KeychainAccessibility.first_unlock_this_device,
  );
  static const _aOptions = AndroidOptions(
    encryptedSharedPreferences: true,
    storageCipherAlgorithm: StorageCipherAlgorithm.AES_GCM_NoPadding,
    keyCipherAlgorithm:
        KeyCipherAlgorithm.RSA_ECB_OAEPwithSHA_256andMGF1Padding,
  );
  static const _storage = FlutterSecureStorage(
    iOptions: _iOptions,
    aOptions: _aOptions,
  );

  late final String pathAppDir;
  late final pathDataDir = '$pathAppDir/data_v1';

  Future<PreferencesService> init() async {
    pathAppDir = (await getApplicationDocumentsDirectory()).path;
    final flagFile = File('$pathAppDir/flags.txt');
    final hasFlag = await flagFile.exists();
    final lastStart = await get<int>(PreferencesKeys.keyLastStart);

    // Error while reading SharedPreferences
    if (hasFlag && lastStart == null) exit(1);

    await set<int>(
      PreferencesKeys.keyLastStart,
      DateTime.timestamp().millisecondsSinceEpoch,
    );
    if (!hasFlag) await flagFile.create(recursive: true);
    return this;
  }

  Future<T?> get<T extends Object>(PreferencesKeys key) => _storage
      .read(
        key: key.name,
        aOptions: _aOptions,
        iOptions: _iOptions,
      )
      .then((value) => value == null
          ? null
          : switch (T) {
              String => value as T,
              int => int.tryParse(value) as T,
              bool => bool.tryParse(value) as T,
              Uint8List => base64Decode(value) as T,
              _ => throw const ValueFormatException(),
            });

  Future<void> set<T extends Object>(PreferencesKeys key, T value) =>
      switch (T) {
        int || bool || String => _storage.write(
            key: key.name,
            value: value.toString(),
            aOptions: _aOptions,
            iOptions: _iOptions,
          ),
        Uint8List => _storage.write(
            key: key.name,
            value: base64UrlEncode(value as Uint8List),
          ),
        _ => throw const ValueFormatException(),
      };
}

class ValueFormatException extends FormatException {
  const ValueFormatException() : super('Unsupported value type');
}
