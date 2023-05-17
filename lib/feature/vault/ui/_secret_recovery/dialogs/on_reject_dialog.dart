import 'package:guardian_keyper/ui/widgets/emoji.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/ui/widgets/icon_of.dart';

import '../../../domain/entity/vault_id.dart';

class OnRejectDialog extends StatelessWidget {
  static Future<void> show(
    BuildContext context, {
    required VaultId vaultId,
  }) =>
      showModalBottomSheet(
        context: context,
        isDismissible: true,
        isScrollControlled: true,
        builder: (_) => OnRejectDialog(vaultId: vaultId),
      );

  const OnRejectDialog({
    super.key,
    required this.vaultId,
  });

  final VaultId vaultId;

  @override
  Widget build(BuildContext context) => BottomSheetWidget(
        icon: const IconOf.secretRestoration(
          isBig: true,
          bage: BageType.error,
        ),
        titleString: 'Guardian rejected the recovery of your Secret',
        textSpan: buildTextWithId(
          leadingText: 'Secret Recovery process for ',
          id: vaultId,
          trailingText: ' has been terminated by your Guardians.',
        ),
        footer: Padding(
          padding: paddingV20,
          child: PrimaryButton(
            text: 'Done',
            onPressed: Navigator.of(context).pop,
          ),
        ),
      );
}
