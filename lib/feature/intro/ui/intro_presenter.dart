import 'package:guardian_keyper/ui/presenters/page_controller_base.dart';
import 'package:guardian_keyper/feature/auth/data/auth_manager.dart';

import 'pages/intros_page.dart';

export 'package:provider/provider.dart';

final class IntroPresenter extends PageControllerBase {
  IntroPresenter({required super.stepsCount});

  final _authManager = GetIt.I<AuthManager>();

  int _introStep = 0;

  int get introStep => _introStep;

  bool get hasBiometrics => _authManager.hasBiometrics;

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

  Future<void> setIsBiometricsEnabled(bool isEnabled) async {
    await _authManager.setIsBiometricsEnabled(isEnabled);
    notifyListeners();
  }
}
