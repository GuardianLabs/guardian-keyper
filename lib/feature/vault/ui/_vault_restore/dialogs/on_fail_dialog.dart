import 'package:guardian_keyper/ui/widgets/common.dart';

class OnFailDialog extends StatelessWidget {
  static Future<void> show(BuildContext context) => showModalBottomSheet(
        context: context,
        isDismissible: true,
        isScrollControlled: true,
        builder: (_) => const OnFailDialog(),
      );

  const OnFailDialog({super.key});

  @override
  Widget build(BuildContext context) => BottomSheetWidget(
        icon: const Icon(Icons.cancel, size: 80),
        titleString: 'Ownership Transfer Failed',
        textString: 'We couldn’t finish Guardian verification.\n'
            'Please try again.',
        footer: FilledButton(
          onPressed: Navigator.of(context).pop,
          child: const Text('Close'),
        ),
      );
}
