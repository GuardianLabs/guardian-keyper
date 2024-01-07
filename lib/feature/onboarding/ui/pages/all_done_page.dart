import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/ui/widgets/stepper_page.dart';

import 'package:guardian_keyper/feature/onboarding/onboarding_presenter.dart';

class AllDonePage extends StatelessWidget {
  const AllDonePage({super.key});

  @override
  Widget build(BuildContext context) {
    final presenter = context.read<OnboardingPresenter>();
    return StepperPage(
      stepCurrent: presenter.currentPage,
      stepsCount: presenter.pageCount,
      child: const Align(
        alignment: Alignment.bottomCenter,
        child: PageTitle(
          icon: Icon(Icons.wallet_rounded, size: 110),
          title: 'You are a Guardian!',
          subtitle: 'Now you can store encrypted parts of entrusted '
              'Secrets and create your own.',
        ),
      ),
      topButton: FilledButton(
        onPressed: () async {
          await presenter.saveDeviceName();
          if (context.mounted) Navigator.of(context).pop();
        },
        child: const Text('Great'),
      ),
    );
  }
}
