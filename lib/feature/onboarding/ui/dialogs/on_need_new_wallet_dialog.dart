import 'package:guardian_keyper/ui/widgets/common.dart';

class OnNeedNewWalletDialog extends StatelessWidget {
  static Future<bool?> show(BuildContext context) => showModalBottomSheet<bool>(
        context: context,
        isScrollControlled: true,
        builder: (_) => const OnNeedNewWalletDialog(),
      );

  const OnNeedNewWalletDialog({super.key});

  @override
  Widget build(BuildContext context) => BottomSheetWidget(
        icon: const Icon(Icons.wallet_rounded, size: 110),
        titleString: 'Set Up Your Wallet',
        textString: 'Choose how you`d like to create your wallet.',
        footer: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Create a New Wallet'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Import a Wallet'),
            ),
          ],
        ),
      );
}
