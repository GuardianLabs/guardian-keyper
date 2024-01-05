import 'package:guardian_keyper/ui/widgets/common.dart';

class OnMessageArchivateDialog extends StatelessWidget {
  static Future<bool?> show(BuildContext context) => showModalBottomSheet<bool>(
        context: context,
        isScrollControlled: true,
        builder: (_) => const OnMessageArchivateDialog(),
      );

  const OnMessageArchivateDialog({super.key});

  @override
  Widget build(BuildContext context) => BottomSheetWidget(
        titleString: 'Are you sure?',
        textString: 'This Request will be moved to Resolved'
            ' and you will not able to Approve it!',
        footer: Row(
          children: [
            Expanded(
              child: FilledButton(
                onPressed: () => Navigator.of(context).pop(false),
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
      );
}
