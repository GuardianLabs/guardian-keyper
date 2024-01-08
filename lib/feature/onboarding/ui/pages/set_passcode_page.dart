import 'package:guardian_keyper/consts.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/ui/utils/screen_size.dart';
import 'package:guardian_keyper/ui/utils/screen_lock.dart';
import 'package:guardian_keyper/ui/widgets/stepper_page.dart';

import 'package:guardian_keyper/feature/onboarding/onboarding_presenter.dart';
import 'package:guardian_keyper/feature/onboarding/widgets/discard_button.dart';

class SetPasscodePage extends StatelessWidget {
  const SetPasscodePage({super.key});

  @override
  Widget build(BuildContext context) {
    final padding = ScreenSize.getPadding(context);
    final presenter = context.read<OnboardingPresenter>();
    return StepperPage(
      stepCurrent: presenter.currentPage,
      stepsCount: presenter.pageCount,
      child: ScreenLock.create(
        useBlur: false,
        digits: passCodeLength,
        keyPadConfig: keyPadConfig,
        inputController: presenter.passcodeInputController,
        config: getScreenLockConfig(context),
        title: Padding(
          padding: padding,
          child: const Text('Create your passcode'),
        ),
        confirmTitle: Padding(
          padding: padding,
          child: const Text('Enter it once more'),
        ),
        onConfirmed: presenter.setPassCode,
        onError: (_) {
          presenter.onPasscodeInputError();
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
}
