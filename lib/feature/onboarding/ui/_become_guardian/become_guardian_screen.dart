import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/ui/widgets/stepper_screen.dart';

import 'package:guardian_keyper/feature/onboarding/ui/pages/set_passcode_page.dart';
import 'package:guardian_keyper/feature/onboarding/ui/pages/set_biometric_logon.dart';
import 'package:guardian_keyper/feature/onboarding/ui/pages/set_device_name_page.dart';
import 'package:guardian_keyper/feature/onboarding/ui/_become_guardian/pages/finish_page.dart';

class BecomeGuardianScreen extends StatelessWidget {
  static const _pages = [
    SetDeviceNamePage(),
    SetPasscodePage(),
    SetBiometricLogonPage(),
    FinishPage(),
  ];

  const BecomeGuardianScreen({super.key});

  @override
  Widget build(BuildContext context) => StepperScreen(
        pages: _pages,
        // Minus one to not treat last screen as a step
        create: (_) => PagePresentererBase(stepsCount: _pages.length - 1),
        onPopInvoked: (_) {},
      );
}
