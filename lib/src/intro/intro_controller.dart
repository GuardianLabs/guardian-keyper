import '/src/core/controller/page_controller_base.dart';
import '/src/settings/settings_cubit.dart';

export 'package:provider/provider.dart';

class IntroController extends PageControllerBase {
  int _introStep = 0;

  IntroController({required super.diContainer, required super.pages});

  int get introStep => _introStep;

  bool get hasBiometrics => GetIt.I<SettingsCubit>().hasBiometrics;

  set introStep(final int value) {
    _introStep = value;
    notifyListeners();
  }
}
