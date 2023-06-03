import 'package:guardian_keyper/ui/widgets/emoji.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/ui/widgets/icon_of.dart';

import '../../../domain/entity/vault_id.dart';

class OnFailDialog extends StatelessWidget {
  static Future<void> show(
    BuildContext context, {
    required VaultId vaultId,
  }) =>
      showModalBottomSheet(
        context: context,
        isDismissible: true,
        isScrollControlled: true,
        builder: (_) => OnFailDialog(vaultId: vaultId),
      );

  const OnFailDialog({
    super.key,
    required this.vaultId,
  });

  final VaultId vaultId;

  @override
  Widget build(BuildContext context) => BottomSheetWidget(
        icon: const IconOf.splitAndShare(isBig: true, bage: BageType.error),
        titleString: 'Something went wrong!',
        textSpan: [
          const TextSpan(text: 'Sharding process for '),
          ...buildTextWithId(id: vaultId),
          const TextSpan(text: ' has been terminated.'),
        ],
        footer: Padding(
          padding: paddingV20,
          child: PrimaryButton(
            text: 'Close',
            onPressed: Navigator.of(context).pop,
          ),
        ),
      );
}
