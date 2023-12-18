import 'package:guardian_keyper/ui/widgets/common.dart';

import 'package:guardian_keyper/feature/vault/domain/entity/vault.dart';

import 'dialogs/on_become_owner_dialog.dart';
import 'dialogs/on_change_owner_dialog.dart';

class ShardShowScreen extends StatelessWidget {
  const ShardShowScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final vault = ModalRoute.of(context)!.settings.arguments! as Vault;
    return ScaffoldSafe(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          HeaderBar(
            caption: vault.id.name,
            backButton: const HeaderBarBackButton(),
          ),
          // Body
          Padding(
            padding: paddingT32 + paddingH20,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Owner name
                Text(
                  vault.ownerId.name,
                  style: theme.textTheme.bodySmall,
                ),
                // Vault name
                Padding(
                  padding: paddingV6,
                  child: Text(
                    vault.id.name,
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                // Vault ID
                Text(
                  'ID: ${vault.id.toHexShort()}',
                  style: theme.textTheme.bodySmall,
                ),
                Padding(
                  padding: paddingT12,
                  child: FilledButton(
                    child: const Text('Show Assistance QR'),
                    onPressed: () => OnChangeOwnerDialog.show(
                      context,
                      vaultId: vault.id,
                    ),
                  ),
                ),
                Padding(
                  padding: paddingT12,
                  child: OutlinedButton(
                    child: const Text('Move Vault to this Device'),
                    onPressed: () => OnBecomeOwnerDialog.show(
                      context,
                      vaultId: vault.id,
                    ),
                  ),
                ),
                Padding(
                  padding: paddingT32,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Secret Shards',
                        style: theme.textTheme.titleLarge,
                      ),
                      Text(
                        vault.secrets.length.toString(),
                        style: theme.textTheme.titleLarge,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Shards List
          Expanded(
            child: ListView(
              padding: paddingH20,
              children: [
                for (final secretShard in vault.secrets.keys)
                  Padding(
                    padding: paddingV6,
                    child: ListTile(
                      title: Text(secretShard.name),
                    ),
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
