import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:wakelock/wakelock.dart';
// import 'package:app_settings/app_settings.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '/src/core/model/core_model.dart';

class PlatformService {
  static const _encryptionPublicKey = 'encryptionPublicKey';
  static const _encryptionPrivateKey = 'encryptionPrivateKey';
  static const _singPublicKey = 'singPublicKey';
  static const _singPrivateKey = 'singPrivateKey';
  static const _encryptionAesKey = 'encryptionAesKey';
  static const _secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  const PlatformService();

  // void openWirelessSettings() => AppSettings.openWirelessSettings();

  Future<void> wakelockEnable() => Wakelock.enable();

  void wakelockDisable() => Wakelock.disable();

  Future<String> getDeviceName([Uint8List? appendix]) async {
    final append = appendix == null
        ? ''
        : [
            ' ',
            appendix.elementAt(0).toRadixString(16).padLeft(2, '0'),
            appendix.elementAt(1).toRadixString(16).padLeft(2, '0'),
            appendix.elementAt(2).toRadixString(16).padLeft(2, '0'),
          ].join().toString();
    try {
      final deviceInfoPlugin = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfoPlugin.androidInfo;
        return '${androidInfo.model}$append';
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfoPlugin.iosInfo;
        return '${iosInfo.model}$append';
      }
    } catch (_) {}
    return 'Undefined$append';
  }

  Future<KeyBunch> readKeyBunch() => _secureStorage.readAll().then(
        (s) => KeyBunch(
          encryptionAesKey: base64Decode(s[_encryptionAesKey] ?? ''),
          encryptionPublicKey: base64Decode(s[_encryptionPublicKey] ?? ''),
          encryptionPrivateKey: base64Decode(s[_encryptionPrivateKey] ?? ''),
          signPublicKey: base64Decode(s[_singPublicKey] ?? ''),
          signPrivateKey: base64Decode(s[_singPrivateKey] ?? ''),
        ),
      );

  Future<KeyBunch> writeKeyBunch(KeyBunch keyBunch) async {
    if (keyBunch.isEmpty) throw Exception('Nothing to write!');
    await _secureStorage.write(
      key: _encryptionAesKey,
      value: base64UrlEncode(keyBunch.encryptionAesKey),
    );
    await _secureStorage.write(
      key: _encryptionPublicKey,
      value: base64UrlEncode(keyBunch.encryptionPublicKey),
    );
    await _secureStorage.write(
      key: _encryptionPrivateKey,
      value: base64UrlEncode(keyBunch.encryptionPrivateKey),
    );
    await _secureStorage.write(
      key: _singPublicKey,
      value: base64UrlEncode(keyBunch.signPublicKey),
    );
    await _secureStorage.write(
      key: _singPrivateKey,
      value: base64UrlEncode(keyBunch.signPrivateKey),
    );
    return keyBunch;
  }
}
