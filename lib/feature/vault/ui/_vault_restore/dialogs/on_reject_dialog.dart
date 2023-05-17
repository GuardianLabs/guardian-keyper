import 'package:guardian_keyper/ui/widgets/emoji.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/ui/widgets/icon_of.dart';
import 'package:guardian_keyper/domain/entity/peer_id.dart';

import '../../../domain/entity/vault_id.dart';

class OnRejectDialog extends StatelessWidget {
  static Future<void> show(
    BuildContext context, {
    required PeerId peerId,
    required VaultId vaultId,
  }) =>
      showModalBottomSheet(
        context: context,
        isDismissible: false,
        isScrollControlled: true,
        builder: (_) => OnRejectDialog(peerId: peerId, vaultId: vaultId),
      );

  const OnRejectDialog({
    super.key,
    required this.peerId,
    required this.vaultId,
  });

  final PeerId peerId;
  final VaultId vaultId;

  @override
  Widget build(BuildContext context) => BottomSheetWidget(
        icon: const IconOf.secrets(isBig: true, bage: BageType.error),
        titleString: 'Ownership Transfer Rejected',
        textSpan: [
          ...buildTextWithId(
            id: peerId,
            trailingText: ' rejected the transfer of ownership for the Vault ',
          ),
          ...buildTextWithId(id: vaultId),
        ],
        body: Padding(
          padding: paddingV20,
          child: Container(
            decoration: boxDecoration,
            padding: paddingAll20,
            child: Text(
              'Since Guardian rejected ownership transfer, '
              'it is impossible to restore the Vault.',
              style: textStyleSourceSansPro416Purple,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        footer: PrimaryButton(
          text: 'Close',
          onPressed: Navigator.of(context).pop,
        ),
      );
}
