import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/ui/widgets/stepper_page.dart';

import 'package:guardian_keyper/feature/onboarding/onboarding_presenter.dart';

class SetBiometricLogonPage extends StatelessWidget {
  const SetBiometricLogonPage({super.key});

  @override
  Widget build(BuildContext context) {
    final presenter = context.read<OnboardingPresenter>();
    return StepperPage(
      stepCurrent: presenter.currentPage,
      stepsCount: presenter.pageCount,
      title: 'Enable Biometrics Login',
      subtitle: 'Would you like to use system biometrics for faster, '
          'easier and secure access to the wallet?',
      topButton: FilledButton(
        onPressed: presenter.hasBiometrics ? presenter.enableBiometrics : null,
        child: const Text('Enable Biometrics'),
      ),
      bottomButton: OutlinedButton(
        onPressed: presenter.nextPage,
        child: const Text('Maybe Later'),
      ),
    );
  }
}
