import 'package:flutter/services.dart';

import 'package:guardian_keyper/consts.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';

class OnShowIdDialog extends StatelessWidget {
  static Future<void> show(
    BuildContext context, {
    required String id,
  }) =>
      showModalBottomSheet(
        context: context,
        isDismissible: true,
        isScrollControlled: true,
        builder: (_) => OnShowIdDialog(id: id),
      );

  const OnShowIdDialog({
    required this.id,
    super.key,
  });

  final String id;

  @override
  Widget build(BuildContext context) => BottomSheetWidget(
        titleString: 'ID',
        textSpan: [
          const TextSpan(text: '0x'),
          TextSpan(
            text: id.substring(0, shortKeyLength),
            style: const TextStyle(color: clGreen),
          ),
          TextSpan(
            text: id.substring(shortKeyLength, id.length - shortKeyLength),
          ),
          TextSpan(
            text: id.substring(id.length - shortKeyLength),
            style: const TextStyle(color: clGreen),
          ),
        ],
        footer: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: Padding(
                padding: paddingH20,
                child: FilledButton(
                  onPressed: () async {
                    await Clipboard.setData(ClipboardData(text: id));
                    if (context.mounted) {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        buildSnackBar(
                          text: 'Public Key has been copied to clipboard.',
                        ),
                      );
                    }
                  },
                  child: const Text('Copy'),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: paddingH20,
                child: OutlinedButton(
                  onPressed: Navigator.of(context).pop,
                  child: const Text('Close'),
                ),
              ),
            ),
          ],
        ),
      );
}
