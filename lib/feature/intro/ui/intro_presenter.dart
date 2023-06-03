import 'package:get_it/get_it.dart';

import 'package:guardian_keyper/consts.dart';
import 'package:guardian_keyper/ui/presenters/page_presenter_base.dart';
import 'package:guardian_keyper/feature/settings/domain/settings_interactor.dart';

export 'package:provider/provider.dart';

class IntroPresenter extends PagePresenterBase {
  IntroPresenter({required super.pageCount});

  final _settingsInteractor = GetIt.I<SettingsInteractor>();

  late String deviceName = _settingsInteractor.deviceName;

  int _introStep = 0;

  int get introStep => _introStep;

  bool get canSaveName => deviceName.length >= minNameLength;

  bool get hasBiometrics => _settingsInteractor.hasBiometrics;

  void nextSlide(int pageCount) {
    if (_introStep == pageCount - 1) {
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
    await _settingsInteractor.setDeviceName(deviceName);
    nextPage();
  }

  Future<void> setIsBiometricsEnabled(bool value) async {
    await _settingsInteractor.setIsBiometricsEnabled(value);
    notifyListeners();
  }
}
