import 'package:get_it/get_it.dart';

import 'package:guardian_keyper/consts.dart';
import 'package:guardian_keyper/ui/presenters/page_presenter_base.dart';
import 'package:guardian_keyper/feature/settings/domain/settings_interactor.dart';

export 'package:provider/provider.dart';

class IntroPresenter extends PagePresenterBase {
  IntroPresenter({required super.pageCount});

  final _settingsInteractor = GetIt.I<SettingsInteractor>();

  late String _deviceName = _settingsInteractor.deviceName;

  int _introStep = 0;

  int get introStep => _introStep;

  String get deviceName => _deviceName;

  bool get canSaveName => _deviceName.length >= minNameLength;

  bool get hasBiometrics => _settingsInteractor.hasBiometrics;

  set introStep(int value) {
    _introStep = value;
    notifyListeners();
  }

  void setDeviceName(String value) {
    _deviceName = value;
    notifyListeners();
  }

  Future<void> saveDeviceName() async {
    await _settingsInteractor.setDeviceName(_deviceName);
    nextPage();
  }

  Future<void> setIsBiometricsEnabled(bool value) async {
    await _settingsInteractor.setIsBiometricsEnabled(value);
    notifyListeners();
  }
}
