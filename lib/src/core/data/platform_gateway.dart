import 'dart:async';
import 'package:wakelock/wakelock.dart';
import 'package:vibration/vibration.dart';
import 'package:local_auth/local_auth.dart';
import 'package:share_plus/share_plus.dart';

class PlatformGateway {
  const PlatformGateway();

  final share = Share.share;

  final vibrate = Vibration.vibrate;

  final wakelockEnable = Wakelock.enable;

  final wakelockDisable = Wakelock.disable;

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
