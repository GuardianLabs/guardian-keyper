import 'package:flutter/services.dart';

import 'package:guardian_keyper/consts.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/ui/theme/brand_colors.dart';

class OnShowIdDialog extends StatelessWidget {
  static Future<void> show(
    BuildContext context, {
    required String id,
  }) =>
      showModalBottomSheet(
        context: context,
        isDismissible: true,
        isScrollControlled: true,
        builder: (_) => OnShowIdDialog(
          id: id,
          highlightColor:
              Theme.of(context).extension<BrandColors>()!.highlightColor,
        ),
      );

  const OnShowIdDialog({
    required this.id,
    required this.highlightColor,
    super.key,
  });

  final String id;
  final Color highlightColor;

  @override
  Widget build(BuildContext context) => BottomSheetWidget(
        titleString: 'ID',
        textSpan: [
          const TextSpan(text: '0x'),
          TextSpan(
            text: id.substring(0, kShortKeyLength),
            style: TextStyle(color: highlightColor),
          ),
          TextSpan(
            text: id.substring(kShortKeyLength, id.length - kShortKeyLength),
          ),
          TextSpan(
            text: id.substring(id.length - kShortKeyLength),
            style: TextStyle(color: highlightColor),
          ),
        ],
        footer: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: Padding(
                padding: paddingHDefault,
                child: FilledButton(
                  onPressed: () async {
                    await Clipboard.setData(ClipboardData(text: id));
                    if (context.mounted) {
                      Navigator.of(context).pop();
                      showSnackBar(
                        context,
                        text: 'Public Key has been copied to clipboard.',
                      );
                    }
                  },
                  child: const Text('Copy'),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: paddingHDefault,
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
