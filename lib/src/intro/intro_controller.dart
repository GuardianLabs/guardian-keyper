import '/src/core/controller/page_controller_base.dart';
import '/src/core/repository/repository_root.dart';
import '/src/settings/settings_repository.dart';
import '/src/auth/auth_case.dart';

export 'package:provider/provider.dart';

class IntroController extends PageControllerBase {
  IntroController(
      {required super.pages, SettingsRepository? settingsRepository})
      : _settingsRepository =
            settingsRepository ?? GetIt.I<RepositoryRoot>().settingsRepository;

  final createPassCode = GetIt.I<AuthCase>().createPassCode;

  final SettingsRepository _settingsRepository;

  late String _deviceName = _settingsRepository.state.deviceName;

  int _introStep = 0;

  int get introStep => _introStep;

  String get deviceName => _deviceName;

  int get maxNameLength => SettingsModel.maxNameLength;

  int get minNameLength => SettingsModel.minNameLength;

  bool get canSaveName => _deviceName.length >= SettingsModel.minNameLength;

  bool get hasBiometrics => _settingsRepository.state.hasBiometrics;

  set introStep(final int value) {
    _introStep = value;
    notifyListeners();
  }

  void setDeviceName(final String value) {
    _deviceName = value;
    notifyListeners();
  }

  Future<void> saveDeviceName() async {
    await _settingsRepository.setDeviceName(_deviceName);
    nextScreen();
  }

  Future<void> setIsBiometricsEnabled(final bool value) async {
    await _settingsRepository.setIsBiometricsEnabled(value);
    notifyListeners();
  }
}
