import 'package:flutter/cupertino.dart';
import 'package:guardian_keyper/consts.dart';
import 'package:guardian_keyper/feature/vault/ui/dialogs/on_change_owner_dialog.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';

import 'package:guardian_keyper/feature/vault/data/vault_repository.dart';

class OnVaultTransferDialog extends StatelessWidget {
  static Future<void> show(
    BuildContext context, {
    required Iterable<Vault> vaults,
  }) =>
      Navigator.of(context).push(
        CupertinoPageRoute(
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
          title: const Text('Helping Restore a Safe'),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        child: Padding(
          padding: paddingHDefault,
          child: Column(
            children: [
              if (vaults.isEmpty)
                const Expanded(
                  child: Center(
                    child: PageTitle(
                      title: 'You do not store any shards yet',
                      subtitle:
                          'When you become a Guardian for someone else`s safe, '
                          'you can help them recover it if they lose access. '
                          'This screen will guide you through the recovery process.',
                    ),
                  ),
                )
              else ...[
                const PageTitle(
                  subtitle: 'Select a Safe to assist with its recovery '
                      'or ownership transfer:',
                ),
                for (final vault in vaults)
                  Padding(
                    padding: paddingV4,
                    child: ListTile(
                      title: Text(vault.id.name),
                      subtitle: Text('Owned by ${vault.ownerId.name}'),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 0,
                        horizontal: kDefaultTilePadding,
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        OnChangeOwnerDialog.show(
                          context,
                          vaultId: vault.id,
                        );
                      },
                    ),
                  )
              ]
            ],
          ),
        ),
      );
}
