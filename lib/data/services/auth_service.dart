import 'package:vibration/vibration.dart';
import 'package:local_auth/local_auth.dart';

class AuthService {
  final _localAuth = LocalAuthentication();

  Future<void> vibrate() => Vibration.vibrate();

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
}
