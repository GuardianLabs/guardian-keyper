import 'package:guardian_keyper/ui/widgets/common.dart';

class OnLimitedAccessDialog extends StatelessWidget {
  static Future<void> show(BuildContext context) => showModalBottomSheet<bool>(
        context: context,
        isDismissible: false,
        isScrollControlled: true,
        builder: (_) => const OnLimitedAccessDialog(),
      );

  const OnLimitedAccessDialog({super.key});

  @override
  Widget build(BuildContext context) => BottomSheetWidget(
        titleString: 'Limited Access',
        textString: 'With limited access, you can restore Secrets, but you '
            'won`t be able to add new Secrets to the Safe. To get full '
            'access, make sure to add all the Guardians linked to the Safe.',
        footer: FilledButton(
          onPressed: Navigator.of(context).pop,
          child: const Text('Got it'),
        ),
      );
}
