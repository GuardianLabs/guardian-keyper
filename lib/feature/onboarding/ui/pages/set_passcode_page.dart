import 'package:guardian_keyper/consts.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/ui/utils/screen_size.dart';
import 'package:guardian_keyper/ui/utils/screen_lock.dart';
import 'package:guardian_keyper/ui/widgets/stepper_page.dart';

import 'package:guardian_keyper/data/managers/auth_manager.dart';
import 'package:guardian_keyper/feature/onboarding/widgets/discard_button.dart';

class SetPasscodePage extends StatefulWidget {
  const SetPasscodePage({super.key});

  @override
  State<SetPasscodePage> createState() => _SetPasscodePageState();
}

class _SetPasscodePageState extends State<SetPasscodePage> {
  final _passcodeInputController = InputController();
  final _authManager = GetIt.I<AuthManager>();

  late final _padding = ScreenSize.getPadding(context);
  late final _presenter = context.read<PagePresentererBase>();

  @override
  void dispose() {
    _passcodeInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => StepperPage(
        stepCurrent: _presenter.currentPage,
        stepsCount: _presenter.stepsCount,
        child: ScreenLock.create(
          useBlur: false,
          digits: passCodeLength,
          keyPadConfig: keyPadConfig,
          inputController: _passcodeInputController,
          config: getScreenLockConfig(context),
          title: Padding(
            padding: _padding,
            child: const Text('Create your passcode'),
          ),
          confirmTitle: Padding(
            padding: _padding,
            child: const Text('Enter it once more'),
          ),
          onConfirmed: (String value) async {
            await _authManager.setPassCode(value);
            await _presenter.nextPage();
          },
          onError: (_) {
            _passcodeInputController.unsetConfirmed();
            _authManager.vibrate();
            showSnackBar(
              context,
              text: 'Wrong passcode!',
              isFloating: true,
              isError: true,
            );
          },
        ),
        bottomButton: const DiscardButton(),
      );
}
