import 'package:guardian_keyper/ui/widgets/common.dart';

class OnFailDialog extends StatelessWidget {
  static Future<void> show(BuildContext context) => showModalBottomSheet(
        context: context,
        isDismissible: false,
        isScrollControlled: true,
        builder: (_) => const OnFailDialog(),
      );

  const OnFailDialog({super.key});

  @override
  Widget build(BuildContext context) => BottomSheetWidget(
        titleString: 'Invalid Code',
        textString: 'Seems like the Code you’ve just used is not valid. '
            'Ask a Guardian to share a new code.',
        icon: const Icon(Icons.cancel, size: 80),
        footer: FilledButton(
          onPressed: Navigator.of(context).pop,
          child: const Text('Close'),
        ),
      );
}
