import 'package:guardian_keyper/ui/widgets/common.dart';

import 'message_titles_mixin.dart';

class OnMessageArchivateDialog extends StatelessWidget with MessageTitlesMixin {
  static Future<bool?> show(BuildContext context) => showModalBottomSheet<bool>(
        context: context,
        useSafeArea: true,
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
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: PrimaryButton(
                text: 'Yes',
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ),
          ],
        ),
      );
}
