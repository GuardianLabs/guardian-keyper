import 'package:guardian_keyper/ui/utils/guardian_icons.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/ui/widgets/styled_icon.dart';

class OnDuplicateDialog extends StatelessWidget {
  static Future<void> show(
    BuildContext context, {
    required String peerName,
  }) =>
      showModalBottomSheet(
        context: context,
        isDismissible: false,
        isScrollControlled: true,
        builder: (_) => OnDuplicateDialog(peerName: peerName),
      );

  const OnDuplicateDialog({
    required this.peerName,
    super.key,
  });

  final String peerName;

  @override
  Widget build(BuildContext context) => BottomSheetWidget(
        icon: StyledIcon(
          icon: GuardianIcons.twice,
          size: 80,
          color: Theme.of(context).colorScheme.error,
        ),
        titleString: 'You can’t add the same Guardian twice',
        textSpan: [
          const TextSpan(
            text: 'Seems like you’ve already added ',
          ),
          TextSpan(
            text: peerName,
            style: styleW600,
          ),
          const TextSpan(
            text: ' to this Safe. Try adding a different Guardian.',
          ),
        ],
        footer: FilledButton(
          onPressed: Navigator.of(context).pop,
          child: const Text('Close'),
        ),
      );
}
