import 'package:guardian_keyper/ui/widgets/common.dart';

import 'package:guardian_keyper/feature/onboarding/enums.dart';

import '../_create_wallet/create_wallet_screen.dart';
import '../_import_wallet/import_wallet_screen.dart';

class OnGetGuardiansDialog extends StatelessWidget {
  static Future<void> show(
    BuildContext context, {
    required ProceedTo proceedTo,
  }) =>
      Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (context) => OnGetGuardiansDialog(proceedTo: proceedTo),
        fullscreenDialog: true,
        maintainState: false,
      ));

  const OnGetGuardiansDialog({
    required this.proceedTo,
    super.key,
  });

  final ProceedTo proceedTo;

  @override
  Widget build(BuildContext context) => ColoredBox(
        color: Theme.of(context).colorScheme.background,
        child: SafeArea(
          minimum: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.shield_outlined, size: 110),
              const PageTitle(
                title: 'Get Guardians Ready',
                subtitle:
                    'Choose at least three Guardians, your trusted people, '
                    'to safeguard parts of your Wallet Recovery Phrase (Seed Phrase). '
                    'Ask them to download the app and press “Become Guardian”.',
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: FilledButton(
                  onPressed: () => Navigator.of(context)
                      .pushReplacement(MaterialPageRoute<void>(
                    builder: (_) => switch (proceedTo) {
                      ProceedTo.create => const CreateWalletScreen(),
                      ProceedTo.import => const ImportWalletScreen(),
                    },
                    fullscreenDialog: true,
                    maintainState: false,
                  )),
                  child: const Text('I Have Guardians, Proceed'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: OutlinedButton(
                  onPressed: Navigator.of(context).pop,
                  child: const Text('I Don`t Have Them Yet'),
                ),
              ),
            ],
          ),
        ),
      );
}
