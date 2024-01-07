import 'package:guardian_keyper/consts.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/ui/widgets/stepper_page.dart';

import 'package:guardian_keyper/feature/onboarding/onboarding_presenter.dart';

class SetDeviceNamePage extends StatelessWidget {
  const SetDeviceNamePage({super.key});

  @override
  Widget build(BuildContext context) {
    final presenter = context.read<OnboardingPresenter>();
    return StepperPage(
      stepCurrent: presenter.currentPage,
      stepsCount: presenter.pageCount,
      title: 'Create a Device Name',
      subtitle: 'This is a name for identifying the device in splitting and '
          'restoring your Recovery Phrase. Make sure it is easily recognizable.',
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: TextFormField(
            maxLength: maxNameLength,
            initialValue: presenter.deviceName,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              labelText: ' Device name ',
              helperText: 'e.g., Jason’s Phone or Jason Cooper, not “My Phone”',
            ),
            onChanged: presenter.onInputChanged,
          ),
        ),
      ],
      topButton: FilledButton(
        onPressed: presenter.canProceed
            ? () async {
                await presenter.saveDeviceName();
              }
            : null,
        child: const Text('Continue'),
      ),
      bottomButton: OutlinedButton(
        onPressed: Navigator.of(context).pop,
        child: const Text('Discard'),
      ),
    );
  }
}
