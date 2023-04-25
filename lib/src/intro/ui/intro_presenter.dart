import 'package:get_it/get_it.dart';
import 'package:flutter/widgets.dart';

import '../../core/consts.dart';
import '/src/core/ui/widgets/auth/auth.dart';
import '/src/core/ui/page_presenter_base.dart';

import '/src/settings/domain/settings_interactor.dart';

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

  Future<void> createPassCode({required final BuildContext context}) =>
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
