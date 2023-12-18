import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/ui/widgets/icon_of.dart';

import 'package:guardian_keyper/feature/vault/domain/entity/vault_id.dart';
import 'package:guardian_keyper/feature/network/domain/entity/peer_id.dart';

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
    required this.peerId,
    required this.vaultId,
    super.key,
  });

  final PeerId peerId;
  final VaultId vaultId;

  @override
  Widget build(BuildContext context) => BottomSheetWidget(
        icon: const IconOf.secrets(isBig: true, bage: BageType.error),
        titleString: 'Ownership Transfer Rejected',
        textSpan: [
          ...buildTextWithId(
            name: peerId.name,
            trailingText: ' rejected the transfer of ownership for the Vault ',
          ),
          ...buildTextWithId(name: vaultId.name),
        ],
        body: Padding(
          padding: paddingV20,
          child: Container(
            decoration: boxDecoration,
            padding: paddingAll20,
            child: Text(
              'Since Guardian rejected ownership transfer, '
              'it is impossible to restore the Vault.',
              style: styleSourceSansPro416Purple,
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
