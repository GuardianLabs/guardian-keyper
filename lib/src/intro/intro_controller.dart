import 'package:flutter/widgets.dart';

import '/src/core/controller/page_controller_base.dart';
import '/src/core/repository/repository_root.dart';
import '/src/core/service/service_root.dart';
import '../core/widgets/auth/auth.dart';

export 'package:provider/provider.dart';

class IntroController extends PageControllerBase {
  IntroController({required super.pages});

  final _serviceRoot = GetIt.I<ServiceRoot>();
  final _settingsRepository = GetIt.I<RepositoryRoot>().settingsRepository;

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

  Future<void> createPassCode({required final BuildContext context}) =>
      showCreatePassCode(
        context: context,
        onVibrate: _serviceRoot.platformService.vibrate,
        onConfirmed: (final String passCode) async {
          await _settingsRepository.setPassCode(passCode);
          if (context.mounted) {
            _settingsRepository.state.hasBiometrics
                ? nextScreen()
                : Navigator.of(context).pop();
          }
        },
      );
}
