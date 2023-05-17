import 'package:guardian_keyper/ui/widgets/emoji.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/ui/widgets/icon_of.dart';
import 'package:guardian_keyper/domain/entity/peer_id.dart';

import '../../../domain/entity/vault.dart';

class OnSuccessDialog extends StatelessWidget {
  static Future<void> show(
    BuildContext context, {
    required Vault vault,
    required PeerId peerId,
  }) =>
      showModalBottomSheet(
        context: context,
        isDismissible: false,
        isScrollControlled: true,
        builder: (_) => OnSuccessDialog(peerId: peerId, vault: vault),
      );

  const OnSuccessDialog({
    super.key,
    required this.vault,
    required this.peerId,
  });

  final PeerId peerId;
  final Vault vault;

  @override
  Widget build(BuildContext context) => vault.isFull
      ? BottomSheetWidget(
          icon: const IconOf.secrets(isBig: true, bage: BageType.ok),
          titleString: 'Ownership Changed',
          textSpan: buildTextWithId(
            leadingText: 'The ownership of the Vault ',
            id: vault.id,
            trailingText: ' has been transferred to your device.',
          ),
          footer: PrimaryButton(
            text: 'Done',
            onPressed: Navigator.of(context).pop,
          ),
        )
      : BottomSheetWidget(
          icon: const IconOf.secrets(isBig: true, bage: BageType.ok),
          titleString: 'Ownership Transfer Approved',
          textSpan: [
            ...buildTextWithId(
              id: peerId,
              trailingText:
                  ' approved the transfer of ownership for the Vault ',
            ),
            ...buildTextWithId(id: vault.id),
          ],
          footer: PrimaryButton(
            text: 'Add another Guardian',
            onPressed: Navigator.of(context).pop,
          ),
        );
}
