import 'package:guardian_keyper/ui/widgets/common.dart';

import 'package:guardian_keyper/feature/onboarding/enums.dart';

import 'on_get_guardians_dialog.dart';

class OnCreateWalletDialog extends StatelessWidget {
  static Future<void> show(BuildContext context) => showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (_) => const OnCreateWalletDialog(),
      );

  const OnCreateWalletDialog({super.key});

  @override
  Widget build(BuildContext context) => BottomSheetWidget(
        icon: const Icon(Icons.wallet_rounded, size: 110),
        titleString: 'Set Up Your Wallet',
        textString: 'Choose how you`d like to create your wallet.',
        footer: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop();
                OnGetGuardiansDialog.show(
                  context,
                  proceedTo: ProceedTo.create,
                );
              },
              child: const Text('Create a New Wallet'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () {
                Navigator.of(context).pop();
                OnGetGuardiansDialog.show(
                  context,
                  proceedTo: ProceedTo.import,
                );
              },
              child: const Text('Import a Wallet'),
            ),
          ],
        ),
      );
}
