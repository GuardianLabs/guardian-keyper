import 'package:guardian_keyper/consts.dart';
import 'package:guardian_keyper/ui/presenters/page_presenter_base.dart';
import 'package:guardian_keyper/feature/network/data/network_manager.dart';
import 'package:guardian_keyper/feature/auth/data/auth_manager.dart';

import 'pages/intros_page.dart';

export 'package:provider/provider.dart';

class IntroPresenter extends PagePresenterBase {
  IntroPresenter({required super.pageCount}) {
    _authManager.getHasBiometrics().then((hasBiometrics) {
      if (hasBiometrics != _hasBiometrics) {
        _hasBiometrics = hasBiometrics;
        notifyListeners();
      }
    });
  }

  final _authManager = GetIt.I<AuthManager>();
  final _networkManager = GetIt.I<NetworkManager>();

  late String deviceName = _networkManager.selfId.name;

  bool _hasBiometrics = false;

  int _introStep = 0;

  int get introStep => _introStep;

  bool get canSaveName => deviceName.length >= minNameLength;

  bool get hasBiometrics => _hasBiometrics;

  void nextSlide() {
    if (_introStep == IntrosPage.slides.length - 1) {
      nextPage();
    } else {
      _introStep++;
      notifyListeners();
    }
  }

  void previousSlide() {
    if (_introStep > 0) {
      _introStep--;
      notifyListeners();
    }
  }

  Future<void> saveDeviceName() async {
    await _networkManager.setDeviceName(deviceName);
    nextPage();
  }

  Future<void> setBiometrics({required bool isEnabled}) async {
    await _authManager.setIsBiometricsEnabled(isEnabled);
    notifyListeners();
  }
}
