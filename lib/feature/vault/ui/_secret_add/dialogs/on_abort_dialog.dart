import 'package:guardian_keyper/ui/widgets/common.dart';

class OnAbortDialog extends StatelessWidget {
  static Future<bool?> show(BuildContext context) => showModalBottomSheet<bool>(
        context: context,
        isScrollControlled: true,
        builder: (_) => const OnAbortDialog(),
      );

  const OnAbortDialog({super.key});

  @override
  Widget build(BuildContext context) => BottomSheetWidget(
        icon: const Icon(Icons.warning_rounded, size: 80),
        titleString: 'Quitting the process',
        textString: 'All progress will be lost, you’ll have to start '
            'from the beginning. Are you sure?',
        footer: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FilledButton(
              onPressed: Navigator.of(context).pop,
              child: const Text('Back to process'),
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Discard & Exit'),
            ),
          ],
        ),
      );
}
