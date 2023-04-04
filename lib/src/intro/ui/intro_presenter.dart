import 'package:flutter/widgets.dart';

import '/src/core/ui/page_presenter_base.dart';
import '/src/core/data/repository_root.dart';
import '/src/core/service/service_root.dart';
import '/src/core/ui/widgets/auth/auth.dart';

export 'package:provider/provider.dart';

class IntroPresenter extends PagePresenterBase {
  IntroPresenter({required super.pages});

  final _serviceRoot = GetIt.I<ServiceRoot>();
  final _settingsRepository = GetIt.I<RepositoryRoot>().settingsRepository;

  late String _deviceName = _settingsRepository.deviceName;

  int _introStep = 0;

  int get introStep => _introStep;

  String get deviceName => _deviceName;

  int get maxNameLength => IdBase.maxNameLength;

  int get minNameLength => IdBase.minNameLength;

  bool get canSaveName => _deviceName.length >= IdBase.minNameLength;

  bool get hasBiometrics => _settingsRepository.hasBiometrics;

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
            _settingsRepository.hasBiometrics
                ? nextScreen()
                : Navigator.of(context).pop();
          }
        },
      );
}
