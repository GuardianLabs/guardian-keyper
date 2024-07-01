import 'package:guardian_keyper/ui/widgets/common.dart';

import 'package:guardian_keyper/feature/vault/data/vault_repository.dart';

import 'package:guardian_keyper/feature/vault/ui/_shard_show/dialogs/on_change_owner_dialog.dart';

class OnVaultTransferDialog extends StatelessWidget {
  static Future<void> show(
    BuildContext context, {
    required Iterable<Vault> vaults,
  }) =>
      Navigator.of(context).push(
        MaterialPageRoute(
          fullscreenDialog: true,
          builder: (_) => OnVaultTransferDialog(vaults: vaults),
        ),
      );

  const OnVaultTransferDialog({
    required this.vaults,
    super.key,
  });

  final Iterable<Vault> vaults;

  @override
  Widget build(BuildContext context) => ScaffoldSafe(
        appBar: AppBar(
          title: const Text('Assist with a Safe'),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        children: [
          const PageTitle(
            subtitle: 'Select a Safe to assist with its recovery '
                'or ownership transfer.',
          ),
          for (final vault in vaults)
            Padding(
              padding: paddingV6,
              child: ListTile(
                title: Text(vault.id.name),
                subtitle: Text('Owned by ${vault.ownerId.name}'),
                onTap: () {
                  Navigator.of(context).pop();
                  OnChangeOwnerDialog.show(
                    context,
                    vaultId: vault.id,
                  );
                },
              ),
            )
        ],
      );
}
