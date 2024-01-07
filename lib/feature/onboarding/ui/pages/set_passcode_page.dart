import 'package:guardian_keyper/consts.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/ui/utils/screen_size.dart';
import 'package:guardian_keyper/ui/utils/screen_lock.dart';
import 'package:guardian_keyper/ui/widgets/stepper_page.dart';

import 'package:guardian_keyper/feature/onboarding/onboarding_presenter.dart';

class SetPasscodePage extends StatefulWidget {
  const SetPasscodePage({super.key});

  @override
  State<SetPasscodePage> createState() => _SetPasscodePageState();
}

class _SetPasscodePageState extends State<SetPasscodePage> {
  final _inputController = InputController();

  late final _padding = ScreenSize.getPadding(context);

  late final _presenter = context.read<OnboardingPresenter>();

  @override
  void initState() {
    super.initState();
    Future.microtask(_showPasscodeDialog);
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => StepperPage(
        stepCurrent: _presenter.currentPage,
        stepsCount: _presenter.pageCount,
      );

  Future<void> _showPasscodeDialog() => screenLockCreate(
        context: context,
        useBlur: false,
        canCancel: false,
        digits: passCodeLength,
        keyPadConfig: keyPadConfig,
        inputController: _inputController,
        config: getScreenLockConfig(context),
        title: Padding(
          padding: _padding,
          child: const Text('Create your passcode'),
        ),
        footer: OutlinedButton(
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
          child: const Text('Discard'),
        ),
        confirmTitle: Padding(
          padding: _padding,
          child: const Text('Enter it once more'),
        ),
        onConfirmed: (passCode) {
          Navigator.of(context).pop();
          _presenter.setPassCode(passCode);
        },
        onError: (_) {
          showSnackBar(
            context,
            text: 'Wrong passcode!',
            isFloating: true,
            isError: true,
          );
          _inputController.unsetConfirmed();
          _presenter.vibrate();
        },
      );
}
