import 'dart:io';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:wakelock/wakelock.dart';
import 'package:vibration/vibration.dart';
import 'package:local_auth/local_auth.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../consts.dart';

class PlatformService {
  static final _connectivity = Connectivity();
  static final _localAuth = LocalAuthentication();

  final share = Share.share;
  final vibrate = Vibration.vibrate;
  final wakelockEnable = Wakelock.enable;
  final wakelockDisable = Wakelock.disable;
  final hasStringsInClipboard = Clipboard.hasStrings;
  final getAvailableBiometrics = _localAuth.getAvailableBiometrics;

  bool get hasWiFi => _connectivityResult == ConnectivityResult.wifi;
  bool get hasConnectivity => _connectivityResult != ConnectivityResult.none;
  bool get hasNoConnectivity => _connectivityResult == ConnectivityResult.none;

  Stream<bool> get onConnectivityChanged => _connectivity.onConnectivityChanged
      .map<bool>((result) => result != ConnectivityResult.none);

  ConnectivityResult _connectivityResult = ConnectivityResult.none;

  Future<String?> copyFromClipboard() async =>
      (await Clipboard.getData(Clipboard.kTextPlain))?.text;

  Future<bool> copyToClipboard(String text) async {
    try {
      await Clipboard.setData(ClipboardData(text: text));
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> checkConnectivity() async {
    _connectivityResult = await _connectivity.checkConnectivity();
    return hasConnectivity;
  }

  Future<Set<InternetAddress>> getIPs() async {
    final result = <InternetAddress>{};
    for (final nIf in await NetworkInterface.list()) {
      result.addAll(nIf.addresses);
    }
    return result;
  }

  Future<String> getDeviceName([String undefinedName = 'Undefined']) async {
    if (Platform.isAndroid) {
      return (await DeviceInfoPlugin().androidInfo).model;
    }
    if (Platform.isIOS) {
      return (await DeviceInfoPlugin().iosInfo).model ?? undefinedName;
    }
    return undefinedName;
  }

  Future<bool> localAuthenticate({
    bool biometricOnly = true,
    String localizedReason = 'Please authenticate to log into the app',
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

  Future<bool> openMarket() =>
      launchUrl(Uri.parse(Platform.isAndroid ? urlPlayMarket : urlAppStore));
}