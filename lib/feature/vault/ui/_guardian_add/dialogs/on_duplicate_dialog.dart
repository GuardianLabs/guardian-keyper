import 'package:guardian_keyper/ui/widgets/emoji.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/ui/widgets/icon_of.dart';
import 'package:guardian_keyper/domain/entity/peer_id.dart';

class OnDuplicateDialog extends StatelessWidget {
  static Future<void> show(
    BuildContext context, {
    required PeerId peerId,
  }) =>
      showModalBottomSheet(
        context: context,
        isDismissible: false,
        isScrollControlled: true,
        builder: (_) => OnDuplicateDialog(peerId: peerId),
      );

  const OnDuplicateDialog({
    super.key,
    required this.peerId,
  });

  final PeerId peerId;

  @override
  Widget build(BuildContext context) => BottomSheetWidget(
        titleString: 'You can’t add the same Guardian twice',
        textSpan: [
          const TextSpan(text: 'Seems like you’ve already added '),
          ...buildTextWithId(id: peerId),
          const TextSpan(
            text: ' to this Vault. Try adding a different Guardian.',
          ),
        ],
        icon: const IconOf.shield(isBig: true, bage: BageType.error),
        footer: PrimaryButton(
          text: 'Close',
          onPressed: Navigator.of(context).pop,
        ),
      );
}
