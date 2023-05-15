import 'package:get_it/get_it.dart';
import 'package:flutter/widgets.dart';

import 'package:guardian_keyper/consts.dart';
import 'package:guardian_keyper/ui/page_presenter_base.dart';
import 'package:guardian_keyper/feature/auth/auth.dart';
import 'package:guardian_keyper/feature/settings/domain/settings_interactor.dart';

export 'package:provider/provider.dart';

class IntroPresenter extends PagePresenterBase {
  IntroPresenter({required super.pages});

  final _settingsInteractor = GetIt.I<SettingsInteractor>();

  late String _deviceName = _settingsInteractor.deviceName;

  int _introStep = 0;

  int get introStep => _introStep;

  String get deviceName => _deviceName;

  bool get canSaveName => _deviceName.length >= minNameLength;

  set introStep(final int value) {
    _introStep = value;
    notifyListeners();
  }

  void setDeviceName(final String value) {
    _deviceName = value;
    notifyListeners();
  }

  Future<void> saveDeviceName() async {
    await _settingsInteractor.setDeviceName(_deviceName);
    nextPage();
  }

  Future<void> setIsBiometricsEnabled(final bool value) async {
    await _settingsInteractor.setIsBiometricsEnabled(value);
    notifyListeners();
  }

  Future<void> createPassCode({required BuildContext context}) =>
      showCreatePassCode(
        context: context,
        onVibrate: _settingsInteractor.vibrate,
        onConfirmed: (final String passCode) async {
          await _settingsInteractor.setPassCode(passCode);
          if (context.mounted) {
            _settingsInteractor.hasBiometrics
                ? nextPage()
                : Navigator.of(context).pop();
          }
        },
      );
}
