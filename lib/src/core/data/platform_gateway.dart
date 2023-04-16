import 'dart:async';
import 'package:wakelock/wakelock.dart';
import 'package:vibration/vibration.dart';
import 'package:local_auth/local_auth.dart';
import 'package:share_plus/share_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class PlatformGateway {
  final share = Share.share;
  final vibrate = Vibration.vibrate;
  final wakelockEnable = Wakelock.enable;
  final wakelockDisable = Wakelock.disable;

  bool get hasWiFi => _connectivityResult == ConnectivityResult.wifi;
  bool get hasConnectivity => _connectivityResult != ConnectivityResult.none;
  bool get hasNoConnectivity => _connectivityResult == ConnectivityResult.none;

  Stream<bool> get onConnectivityChanged => _connectivity.onConnectivityChanged
      .map<bool>((result) => result != ConnectivityResult.none);

  final _connectivity = Connectivity();

  ConnectivityResult _connectivityResult = ConnectivityResult.none;

  Future<bool> checkConnectivity() async {
    _connectivityResult = await _connectivity.checkConnectivity();
    return hasConnectivity;
  }

  Future<bool> localAuthenticate({
    final bool biometricOnly = true,
    final String localizedReason = 'Please authenticate to log into the app',
  }) async {
    try {
      return await LocalAuthentication().authenticate(
        localizedReason: localizedReason,
        options: AuthenticationOptions(biometricOnly: biometricOnly),
      );
    } catch (_) {
      return false;
    }
  }
}
