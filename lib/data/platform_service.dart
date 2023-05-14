import 'dart:io';
import 'dart:async';
import 'package:get_it/get_it.dart';
import 'package:wakelock/wakelock.dart';
import 'package:vibration/vibration.dart';
import 'package:local_auth/local_auth.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../domain/entity/env.dart';

class PlatformService {
  static final _connectivity = Connectivity();
  static final _localAuth = LocalAuthentication();

  final share = Share.share;
  final vibrate = Vibration.vibrate;
  final wakelockEnable = Wakelock.enable;
  final wakelockDisable = Wakelock.disable;
  final getAvailableBiometrics = _localAuth.getAvailableBiometrics;

  bool get hasWiFi => _connectivityResult == ConnectivityResult.wifi;
  bool get hasConnectivity => _connectivityResult != ConnectivityResult.none;
  bool get hasNoConnectivity => _connectivityResult == ConnectivityResult.none;

  Stream<bool> get onConnectivityChanged => _connectivity.onConnectivityChanged
      .map<bool>((result) => result != ConnectivityResult.none);

  ConnectivityResult _connectivityResult = ConnectivityResult.none;

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

  Future<String> getDeviceName([final undefinedName = 'Undefined']) async {
    if (Platform.isAndroid) {
      return (await DeviceInfoPlugin().androidInfo).model;
    }
    if (Platform.isIOS) {
      return (await DeviceInfoPlugin().iosInfo).model ?? undefinedName;
    }
    return undefinedName;
  }

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

  Future<bool> openMarket() => launchUrl(
        Uri.parse(Platform.isAndroid ? _env.urlPlayMarket : _env.urlAppStore),
      );

  final _env = GetIt.I<Env>();
}
