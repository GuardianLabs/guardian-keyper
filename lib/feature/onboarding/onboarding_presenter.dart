import 'package:guardian_keyper/consts.dart';
import 'package:guardian_keyper/ui/presenters/page_presenter_base.dart';

import 'package:guardian_keyper/feature/auth/data/auth_manager.dart';
import 'package:guardian_keyper/feature/network/data/network_manager.dart';

export 'package:provider/provider.dart';

final class OnboardingPresenter extends PagePresenterBase {
  OnboardingPresenter({required super.pageCount});

  final _authManager = GetIt.I<AuthManager>();
  final _networkManager = GetIt.I<NetworkManager>();

  late String _deviceName = _networkManager.selfId.name;

  String get deviceName => _deviceName;

  bool get canProceed => _deviceName.length >= minNameLength;

  bool get hasBiometrics => _authManager.hasBiometrics;

  Future<void> vibrate() => _authManager.vibrate();

  Future<void> setPassCode(String value) async {
    await _authManager.setPassCode(value);
    nextPage();
  }

  void onInputChanged(String value) {
    _deviceName = value;
    if (value.length >= minNameLength && !canProceed) {
      notifyListeners();
    } else if (value.length < minNameLength && canProceed) {
      notifyListeners();
    }
  }

  Future<void> setIsBiometricsEnabled(bool isEnabled) async {
    await _authManager.setIsBiometricsEnabled(isEnabled);
    notifyListeners();
  }

  Future<void> saveDeviceName() async {
    await _networkManager.setDeviceName(_deviceName);
    nextPage();
  }
}
