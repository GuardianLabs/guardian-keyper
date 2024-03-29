import 'package:guardian_keyper/ui/widgets/common.dart';

import 'package:guardian_keyper/feature/vault/domain/entity/vault_id.dart';

import 'on_vault_remove_dialog.dart';

class OnVaultMoreDialog extends StatelessWidget {
  static Future<void> show(
    BuildContext context, {
    required VaultId vaultId,
  }) =>
      showModalBottomSheet<bool>(
        context: context,
        isScrollControlled: true,
        builder: (_) => OnVaultMoreDialog(vaultId: vaultId),
      );

  const OnVaultMoreDialog({
    required this.vaultId,
    super.key,
  });

  final VaultId vaultId;

  @override
  Widget build(BuildContext context) => BottomSheetWidget(
        footer: FilledButton(
          child: const Text('Remove the Safe'),
          onPressed: () {
            Navigator.of(context).pop();
            OnVaultRemoveDialog.show(context, vaultId: vaultId);
          },
        ),
      );
}
