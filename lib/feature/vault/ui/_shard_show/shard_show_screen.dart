import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/ui/utils/screen_size.dart';

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
      header: HeaderBar(
        caption: vault.id.name,
        leftButton: const HeaderBarButton.back(),
      ),
      children: [
        // Owner name
        Padding(
          padding: switch (ScreenSize.get(MediaQuery.of(context).size)) {
            ScreenSmall _ => paddingT12,
            ScreenMedium _ => paddingT20,
            _ => const EdgeInsets.only(top: 32),
          },
          child: Text(
            vault.ownerId.name,
            style: theme.textTheme.bodySmall,
          ),
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
          padding: const EdgeInsets.only(top: 32, bottom: 12),
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
        // Shards List
        for (final secretShard in vault.secrets.keys)
          Padding(
            padding: paddingV6,
            child: ListTile(
              title: Text(secretShard.name),
            ),
          ),
      ],
    );
  }
}
