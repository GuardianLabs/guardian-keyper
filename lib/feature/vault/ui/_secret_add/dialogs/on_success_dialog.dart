import 'package:guardian_keyper/ui/widgets/common.dart';

class OnSuccessDialog extends StatelessWidget {
  static Future<void> show(BuildContext context) => showModalBottomSheet(
        context: context,
        isDismissible: true,
        isScrollControlled: true,
        builder: (_) => const OnSuccessDialog(),
      );

  const OnSuccessDialog({super.key});

  @override
  Widget build(BuildContext context) => BottomSheetWidget(
        icon: const Icon(Icons.check_circle, size: 80),
        titleString: 'Secret Added Successfully!',
        textString: 'Your Secret is now securely stored in the Safe, '
            'and each Guardian has received a shard to ensure enhanced security.',
        footer: FilledButton(
          onPressed: Navigator.of(context).pop,
          child: const Text('Go to Safe'),
        ),
      );
}
