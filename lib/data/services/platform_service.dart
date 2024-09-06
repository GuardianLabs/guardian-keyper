import 'dart:io';
import 'dart:async';
import 'dart:ui';

import 'package:share_plus/share_plus.dart';
import 'package:vibration/vibration.dart';
import 'package:local_auth/local_auth.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';

import 'package:guardian_keyper/consts.dart';

class PlatformService {
  static final _localAuth = LocalAuthentication();

  Future<String> getDeviceName([String undefinedName = 'Undefined']) async {
    if (Platform.isAndroid) {
      return (await DeviceInfoPlugin().androidInfo).model;
    }
    if (Platform.isIOS) {
      return (await DeviceInfoPlugin().iosInfo).model;
    }
    return undefinedName;
  }

  Future<bool> getHasBiometrics() =>
      _localAuth.getAvailableBiometrics().then((value) => value.isNotEmpty);

  Future<bool> localAuthenticate({
    required bool biometricOnly,
    required String localizedReason,
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

  Future<void> share(
    String text, {
    String? subject,
    Rect? sharePositionOrigin,
  }) =>
      Share.share(
        text,
        subject: subject,
        sharePositionOrigin: sharePositionOrigin,
      );

  Future<bool> openMarket() =>
      launchUrl(Uri.parse(Platform.isAndroid ? urlPlayMarket : urlAppStore));

  Future<void> wakelockDisable() => WakelockPlus.disable();

  Future<void> wakelockEnable() => WakelockPlus.enable();

  Future<bool> openUrl(Uri url) => launchUrl(url);

  Future<void> vibrate() => Vibration.vibrate();
}
