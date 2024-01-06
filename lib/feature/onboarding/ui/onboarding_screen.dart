import 'package:guardian_keyper/ui/widgets/common.dart';

import '_become_guardian/become_guardian_screen.dart';
import 'dialogs/on_create_wallet_dialog.dart';

class OnboardingScreen extends StatelessWidget {
  static const route = '/onboarding';

  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PopScope(
      canPop: false,
      child: ColoredBox(
        color: const Color(0xFF5A37E6),
        child: SafeArea(
          minimum: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Expanded(
                child: Placeholder(child: Center(child: Text('lottie'))),
              ),
              Padding(
                padding: paddingV20,
                child: Text(
                  'Guardian Wallet',
                  style: theme.textTheme.headlineLarge?.copyWith(
                    color: theme.colorScheme.onPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Text(
                'Experience enhanced security and ease '
                'of recovery with a hybrid custody Web3 wallet.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              // Create a Wallet
              FilledButton.tonal(
                onPressed: () => OnCreateWalletDialog.show(context),
                child: const Text('Create a Wallet'),
              ),
              const SizedBox(height: 12),
              // Become a Guardian
              FilledButton(
                style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Color(0xFF8D6AF5)),
                ),
                onPressed: () =>
                    Navigator.of(context).push(MaterialPageRoute<void>(
                  builder: (context) => const BecomeGuardianScreen(),
                  fullscreenDialog: true,
                  maintainState: false,
                )),
                child: const Text('Become a Guardian'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
