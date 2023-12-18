import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/ui/widgets/icon_of.dart';

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
            'Ask Guardian to share a new code.',
        icon: const IconOf.shield(isBig: true, bage: BageType.error),
        footer: SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: Navigator.of(context).pop,
            child: const Text('Close'),
          ),
        ),
      );
}
