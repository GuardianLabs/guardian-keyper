import 'dart:io';
import 'dart:async';
import 'dart:typed_data';
import 'package:local_auth/local_auth.dart';
import 'package:device_info_plus/device_info_plus.dart';

import 'package:guardian_keyper/src/core/app/consts.dart';
import 'package:guardian_keyper/src/core/data/secure_storage.dart';

class SettingsManager {
  SettingsManager({
    final SecureStorage? secureStorage,
    final LocalAuthentication? localAuth,
  })  : _localAuth = localAuth ?? LocalAuthentication(),
        _storage = secureStorage ?? SecureStorage(storage: Storages.settings);

  String get passCode => _passCode;
  String get deviceName => _deviceName;
  bool get hasBiometrics => _hasBiometrics;
  bool get isBootstrapEnabled => _isBootstrapEnabled;
  bool get isBiometricsEnabled => _isBiometricsEnabled;

  Stream<MapEntry<String, Object>> get changes =>
      _updatesStreamController.stream;

  final SecureStorage _storage;
  final LocalAuthentication _localAuth;

  final _updatesStreamController =
      StreamController<MapEntry<String, Object>>.broadcast();

  late String _passCode, _deviceName;
  late bool _isBiometricsEnabled, _isBootstrapEnabled, _hasBiometrics;

  Future<void> init() async {
    // Ugly hack to fix first read returns null
    await _storage.get<String>(keyDeviceName);

    _passCode = await _storage.get<String>(keyPassCode) ?? '';
    _isBootstrapEnabled =
        await _storage.get<bool>(keyIsBootstrapEnabled) ?? true;
    _isBiometricsEnabled =
        await _storage.get<bool>(keyIsBiometricsEnabled) ?? true;
    _deviceName =
        await _storage.get<String>(keyDeviceName) ?? await _getDeviceName();

    await getHasBiometrics();
  }

  Future<bool> getHasBiometrics() => _localAuth
      .getAvailableBiometrics()
      .then((value) => _hasBiometrics = value.isNotEmpty);

  Future<void> setDeviceName(final String value) async {
    _deviceName = value;
    await _storage.set<String>(keyDeviceName, value);
    _updatesStreamController.add(MapEntry(keyDeviceName, value));
  }

  Future<void> setPassCode(final String value) async {
    _passCode = value;
    await _storage.set<String>(keyPassCode, value);
    _updatesStreamController.add(MapEntry(keyPassCode, value));
  }

  Future<void> setIsBootstrapEnabled(final bool value) async {
    _isBootstrapEnabled = value;
    await _storage.set<bool>(keyIsBootstrapEnabled, value);
    _updatesStreamController.add(MapEntry(keyIsBootstrapEnabled, value));
  }

  Future<void> setIsBiometricsEnabled(final bool value) async {
    _isBiometricsEnabled = value;
    await _storage.set<bool>(keyIsBiometricsEnabled, value);
    _updatesStreamController.add(MapEntry(keyIsBiometricsEnabled, value));
  }

  Future<String> _getDeviceName({
    final int maxNameLength = maxTokenNameLength,
    final Uint8List? append,
  }) async {
    var result = 'Undefined';
    try {
      final deviceInfoPlugin = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        result = (await deviceInfoPlugin.androidInfo).model;
      } else if (Platform.isIOS) {
        result = (await deviceInfoPlugin.iosInfo).model!;
      }
    } catch (_) {}
    if (append != null) {
      result = [
        '$result ',
        append.elementAt(0).toRadixString(16).padLeft(2, '0'),
        append.elementAt(1).toRadixString(16).padLeft(2, '0'),
        append.elementAt(2).toRadixString(16).padLeft(2, '0'),
      ].join().toString();
    }
    if (result.length > maxNameLength) {
      return result.substring(0, maxNameLength);
    }
    return result;
  }
}
