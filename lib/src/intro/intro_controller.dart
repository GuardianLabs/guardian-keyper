import 'package:guardian_keyper/src/core/di_container.dart';

import '/src/core/controller/page_controller_base.dart';

export 'package:provider/provider.dart';

class IntroController extends PageControllerBase {
  late final globals = diContainer.globals;

  int _introStep = 0;

  late String _deviceName = diContainer.boxSettings.deviceName;

  IntroController({required super.diContainer, required super.pages});

  int get introStep => _introStep;

  String get deviceName => _deviceName;

  set introStep(final int value) {
    _introStep = value;
    notifyListeners();
  }

  set deviceName(final String value) {
    _deviceName = value;
    notifyListeners();
  }

  void Function()? onSaveDeviceName() =>
      deviceName.length < globals.minNameLength
          ? null
          : () {
              diContainer.boxSettings.deviceName = _deviceName;
              nextScreen();
            };
}
