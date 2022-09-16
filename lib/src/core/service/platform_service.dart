import 'dart:io';
import 'dart:convert';
import 'package:vibration/vibration.dart';
import 'package:local_auth/local_auth.dart';
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
  static final _localAuth = LocalAuthentication();

  static Future<PlatformService> bootstrap() async => PlatformService(
      hasBiometrics: await PlatformService.checkIfHasBiometrics());

  static Future<bool> checkIfHasBiometrics() async =>
      (await _localAuth.getAvailableBiometrics()).isNotEmpty;

  final bool hasBiometrics;

  const PlatformService({this.hasBiometrics = false});

  Future<void> vibrate([int duration = 500]) async =>
      (await Vibration.hasVibrator() ?? false)
          ? await Vibration.vibrate(duration: duration)
          : null;

  Future<bool> authenticate({required String localizedReason}) async {
    try {
      return await _localAuth.authenticate(
        localizedReason: localizedReason,
        options: const AuthenticationOptions(biometricOnly: true),
      );
    } catch (_) {}
    return false;
  }

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

  Future<KeyBunch> getKeyBunch(Future<KeyBunch> Function() genKeyBunch) async {
    KeyBunch? keyBunch;
    try {
      keyBunch = await _readKeyBunch();
    } catch (_) {}
    if (keyBunch == null) {
      await _writeKeyBunch(await genKeyBunch());
    } else {
      return keyBunch;
    }
    final newKeyBunch = await _readKeyBunch();
    if (newKeyBunch == null) throw Exception('Can`t persist keyBunch!');
    return newKeyBunch;
  }

  Future<KeyBunch?> _readKeyBunch() async {
    late String encryptionAesKey;
    late String encryptionPublicKey;
    late String encryptionPrivateKey;
    late String singPublicKey;
    late String singPrivateKey;

    try {
      encryptionPublicKey =
          await _secureStorage.read(key: _encryptionPublicKey) ?? '';
      encryptionPrivateKey =
          await _secureStorage.read(key: _encryptionPrivateKey) ?? '';
      singPublicKey = await _secureStorage.read(key: _singPublicKey) ?? '';
      singPrivateKey = await _secureStorage.read(key: _singPrivateKey) ?? '';
      encryptionAesKey =
          await _secureStorage.read(key: _encryptionAesKey) ?? '';
    } catch (_) {
      await _secureStorage.deleteAll();
      return null;
    }

    if (encryptionPublicKey.isEmpty ||
        encryptionPrivateKey.isEmpty ||
        singPublicKey.isEmpty ||
        singPrivateKey.isEmpty ||
        encryptionAesKey.isEmpty) {
      await _secureStorage.deleteAll();
      return null;
    }

    try {
      return KeyBunch(
        encryptionPublicKey: base64Decode(encryptionPublicKey),
        encryptionPrivateKey: base64Decode(encryptionPrivateKey),
        singPublicKey: base64Decode(singPublicKey),
        singPrivateKey: base64Decode(singPrivateKey),
        encryptionAesKey: base64Decode(encryptionAesKey),
      );
    } catch (_) {
      await _secureStorage.deleteAll();
      return null;
    }
  }

  Future<void> _writeKeyBunch(KeyBunch keyBunch) async {
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
      value: base64UrlEncode(keyBunch.singPublicKey),
    );
    await _secureStorage.write(
      key: _singPrivateKey,
      value: base64UrlEncode(keyBunch.singPrivateKey),
    );
    await _secureStorage.write(
      key: _encryptionAesKey,
      value: base64UrlEncode(keyBunch.encryptionAesKey),
    );
  }
}
