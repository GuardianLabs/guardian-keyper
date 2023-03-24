import 'dart:io';
import 'dart:async';
import 'dart:typed_data';
import 'package:wakelock/wakelock.dart';
import 'package:vibration/vibration.dart';
import 'package:local_auth/local_auth.dart';
import 'package:share_plus/share_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';

class PlatformService {
  static final _localAuth = LocalAuthentication();

  const PlatformService();

  final share = Share.share;

  final vibrate = Vibration.vibrate;

  final wakelockEnable = Wakelock.enable;

  final wakelockDisable = Wakelock.disable;

  Future<bool> getHasBiometrics() =>
      _localAuth.getAvailableBiometrics().then((value) => value.isNotEmpty);

  Future<bool> localAuthenticate({
    final bool biometricOnly = true,
    final String localizedReason = 'Please authenticate to log into the app',
  }) async {
    try {
      return await _localAuth.authenticate(
        localizedReason: localizedReason,
        options: AuthenticationOptions(biometricOnly: biometricOnly),
      );
    } catch (_) {
      return false;
    }
  }

  Future<String> getDeviceName({
    required final int maxNameLength,
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
