import 'package:flutter/services.dart';

import 'package:guardian_keyper/app/routes.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';

import 'dialogs/on_need_new_wallet_dialog.dart';

class OnboardingScreen extends StatelessWidget {
  static const route = '/onboarding';

  static const _darkOverlay = SystemUiOverlayStyle(
    // statusBarColor: Colors.transparent,
    statusBarBrightness: Brightness.dark,
    statusBarIconBrightness: Brightness.light,
  );

  static const _lightOverlay = SystemUiOverlayStyle(
    // statusBarColor: Colors.transparent,
    statusBarBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.dark,
  );

  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    SystemChrome.setSystemUIOverlayStyle(_darkOverlay);
    return ColoredBox(
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
            FilledButton.tonal(
              onPressed: () async {
                final result = await OnNeedNewWalletDialog.show(context);
                if (result == null) return;
                SystemChrome.setSystemUIOverlayStyle(_lightOverlay);
                if (context.mounted) {
                  Navigator.of(context).pushReplacementNamed(
                    routeWalletCreateWizard,
                  );
                }
              },
              child: const Text('Create a Wallet'),
            ),
            const SizedBox(height: 12),
            FilledButton(
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Color(0xFF8D6AF5)),
              ),
              onPressed: () {},
              child: const Text('Become a Guardian'),
            ),
          ],
        ),
      ),
    );
  }
}
