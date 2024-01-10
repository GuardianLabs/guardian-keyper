import 'package:guardian_keyper/ui/widgets/common.dart';

class OnDiscardDialog extends StatelessWidget {
  static Future<bool?> show(BuildContext context) => showModalBottomSheet<bool>(
        context: context,
        isScrollControlled: true,
        builder: (_) => const OnDiscardDialog(),
      );

  const OnDiscardDialog({super.key});

  @override
  Widget build(BuildContext context) => BottomSheetWidget(
        icon: const Icon(Icons.error_outline, size: 110),
        titleString: 'Discard the Process?',
        textString: 'Any information entered will be lost. '
            'This action cannot be undone.',
        footer: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FilledButton(
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(
                    Theme.of(context).colorScheme.error),
              ),
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Discard'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: Navigator.of(context).pop,
              child: const Text('Continue'),
            ),
          ],
        ),
      );
}
