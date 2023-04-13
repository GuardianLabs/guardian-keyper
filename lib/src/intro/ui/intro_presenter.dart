import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

import '/src/core/consts.dart';
import '/src/core/data/platform_manager.dart';
import '/src/core/ui/widgets/auth/auth.dart';
import '/src/core/ui/page_presenter_base.dart';
import '/src/settings/data/settings_repository.dart';

export 'package:provider/provider.dart';

class IntroPresenter extends PagePresenterBase {
  IntroPresenter({required super.pages});

  final _settingsRepository = GetIt.I<SettingsRepository>();

  late String _deviceName = _settingsRepository.settings.deviceName;

  int _introStep = 0;

  int get introStep => _introStep;

  String get deviceName => _deviceName;

  int get maxNameLength => maxTokenNameLength;

  int get minNameLength => minTokenNameLength;

  bool get canSaveName => _deviceName.length >= minTokenNameLength;

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
        onVibrate: GetIt.I<PlatformManager>().vibrate,
        onConfirmed: (final String passCode) async {
          await _settingsRepository.setPassCode(passCode);
          if (context.mounted) {
            GetIt.I<PlatformManager>().hasBiometrics
                ? nextScreen()
                : Navigator.of(context).pop();
          }
        },
      );
}
