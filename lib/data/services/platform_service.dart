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

import 'package:guardian_keyper/consts.dart';

typedef ConnectivityState = ({bool hasConnectivity, bool hasWiFi});

class PlatformService {
  static final _connectivity = Connectivity();
  static final _localAuth = LocalAuthentication();

  final share = Share.share;
  final vibrate = Vibration.vibrate;
  final wakelockEnable = Wakelock.enable;
  final wakelockDisable = Wakelock.disable;
  final hasStringsInClipboard = Clipboard.hasStrings;

  late final onConnectivityChanged =
      _connectivity.onConnectivityChanged.map<ConnectivityState>((type) {
    _connectivityType = type;
    return (
      hasConnectivity: type != ConnectivityResult.none,
      hasWiFi: type == ConnectivityResult.wifi,
    );
  });

  bool get hasWiFi => _connectivityType == ConnectivityResult.wifi;
  bool get hasConnectivity => _connectivityType != ConnectivityResult.none;
  bool get hasNoConnectivity => _connectivityType == ConnectivityResult.none;

  ConnectivityResult _connectivityType = ConnectivityResult.none;

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
    _connectivityType = await _connectivity.checkConnectivity();
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

  Future<bool> getHasBiometrics() =>
      _localAuth.getAvailableBiometrics().then((value) => value.isNotEmpty);

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
