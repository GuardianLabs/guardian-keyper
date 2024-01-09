import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/ui/widgets/stepper_page.dart';

import 'package:guardian_keyper/feature/auth/data/auth_manager.dart';

class SetBiometricLogonPage extends StatelessWidget {
  const SetBiometricLogonPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authManager = GetIt.I<AuthManager>();
    final presenter = context.read<PageControllerBase>();
    return StepperPage(
      stepCurrent: presenter.currentPage,
      stepsCount: presenter.stepsCount,
      title: 'Enable Biometrics Login',
      subtitle: 'Would you like to use system biometrics for faster, '
          'easier and secure access to the wallet?',
      topButton: FilledButton(
        onPressed: authManager.hasBiometrics
            ? () async {
                await authManager.setIsBiometricsEnabled(true);
                await presenter.nextPage();
              }
            : null,
        child: const Text('Enable Biometrics'),
      ),
      bottomButton: OutlinedButton(
        onPressed: presenter.nextPage,
        child: const Text('Maybe Later'),
      ),
    );
  }
}
