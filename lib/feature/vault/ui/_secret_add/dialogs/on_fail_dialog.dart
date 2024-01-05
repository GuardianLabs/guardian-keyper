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
        icon: const Icon(Icons.warning_rounded, size: 80),
        titleString: 'Something went wrong!',
        textString: 'Sharding process has been terminated.',
        footer: FilledButton(
          onPressed: Navigator.of(context).pop,
          child: const Text('Go to Safe'),
        ),
      );
}
