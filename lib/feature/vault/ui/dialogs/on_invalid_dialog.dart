import 'package:guardian_keyper/ui/widgets/common.dart';

class OnInvalidDialog extends StatelessWidget {
  static Future<void> show(BuildContext context) => showModalBottomSheet(
        context: context,
        isDismissible: true,
        isScrollControlled: true,
        builder: (_) => const OnInvalidDialog(),
      );

  const OnInvalidDialog({super.key});

  @override
  Widget build(BuildContext context) => BottomSheetWidget(
        icon: const Icon(Icons.cancel, size: 80),
        titleString: 'Invalid Code',
        textString: 'Seems like the Code you’ve just used '
            'is not valid. Ask Guardian to share a new code.',
        footer: FilledButton(
          onPressed: Navigator.of(context).pop,
          child: const Text('Close'),
        ),
      );
}
