import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/ui/widgets/icon_of.dart';

class OnAbortDialog extends StatelessWidget {
  static Future<bool?> show(BuildContext context) => showModalBottomSheet<bool>(
        context: context,
        isScrollControlled: true,
        builder: (_) => const OnAbortDialog(),
      );

  const OnAbortDialog({super.key});

  @override
  Widget build(BuildContext context) => BottomSheetWidget(
        icon: const IconOf.splitAndShare(isBig: true, bage: BageType.error),
        titleString: 'Cancel adding a Secret?',
        textString: 'All progress will be lost, you’ll have to start '
            'from the beginning. Are you sure?',
        footer: Padding(
          padding: paddingV20,
          child: Row(
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: Navigator.of(context).pop,
                  child: const Text('No'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Yes'),
                ),
              ),
            ],
          ),
        ),
      );
}
