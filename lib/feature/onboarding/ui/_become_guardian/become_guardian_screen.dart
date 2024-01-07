import 'package:guardian_keyper/ui/widgets/common.dart';

import 'package:guardian_keyper/feature/onboarding/onboarding_presenter.dart';
import 'package:guardian_keyper/feature/onboarding/ui/pages/all_done_page.dart';
import 'package:guardian_keyper/feature/onboarding/ui/pages/set_passcode_page.dart';
import 'package:guardian_keyper/feature/onboarding/ui/pages/set_device_name_page.dart';

class BecomeGuardianScreen extends StatelessWidget {
  static const _pages = [
    SetPasscodePage(),
    SetDeviceNamePage(),
    AllDonePage(),
  ];

  const BecomeGuardianScreen({super.key});

  @override
  Widget build(BuildContext context) => PopScope(
        canPop: false,
        child: ChangeNotifierProvider(
          create: (_) => OnboardingPresenter(pageCount: _pages.length),
          builder: (context, _) {
            final currentPage =
                context.select<OnboardingPresenter, int>((p) => p.currentPage);
            return _pages[currentPage];
          },
        ),
      );
}
