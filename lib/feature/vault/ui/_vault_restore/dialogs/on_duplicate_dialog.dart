import 'package:guardian_keyper/ui/widgets/common.dart';

class OnDuplicateDialog extends StatelessWidget {
  static Future<void> show(BuildContext context) => showModalBottomSheet(
        context: context,
        isDismissible: false,
        isScrollControlled: true,
        builder: (_) => const OnDuplicateDialog(),
      );

  const OnDuplicateDialog({super.key});

  @override
  Widget build(BuildContext context) => BottomSheetWidget(
        icon: const Icon(Icons.check_circle, size: 80),
        titleString: 'The Vault is yours',
        textString: 'Seems like you are the owner of the Vault already. '
            'No recovery required here.',
        footer: FilledButton(
          onPressed: Navigator.of(context).pop,
          child: const Text('Close'),
        ),
      );
}
