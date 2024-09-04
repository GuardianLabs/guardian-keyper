import 'package:guardian_keyper/consts.dart';
import 'package:guardian_keyper/feature/vault/ui/dialogs/on_become_owner_dialog.dart';
import 'package:guardian_keyper/feature/vault/ui/dialogs/on_change_owner_dialog.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';

import 'package:guardian_keyper/feature/vault/domain/entity/vault.dart';

class ShardsListTile extends StatelessWidget {
  const ShardsListTile({
    required this.vault,
    super.key,
  });

  final Vault vault;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(kCornerRadius),
        ),
        color: theme.colorScheme.surface,
      ),
      child: IgnorePointer(
        ignoring: vault.hasNoSecrets,
        child: ExpansionTile(
          key: PageStorageKey(vault.id.name),
          visualDensity: VisualDensity.standard,
          minTileHeight: 88,
          title: Text(vault.id.name),
          subtitle: Text(
            'Owner: ${vault.ownerId.name}\n'
            '${vault.secrets.length} Shard(s)',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            strutStyle: const StrutStyle(height: 1.5),
          ),
          childrenPadding: EdgeInsets.zero,
          showTrailingIcon: !vault.hasNoSecrets,
          children: [
            const Divider(
              height: 1,
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: kDefaultTilePadding,
                    vertical: kCornerRadius,
                  ),
                  child: Column(
                    children: vault.secrets.keys
                        .map(
                          (secretShard) => Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              secretShard.name,
                              style: theme.listTileTheme.titleTextStyle,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Padding(
                    padding: paddingB12,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        FilledButton(
                          onPressed: () => OnBecomeOwnerDialog.show(
                            context,
                            vault: vault,
                          ),
                          child: const Text('Own Safe'),
                        ),
                        FilledButton(
                          onPressed: () => OnChangeOwnerDialog.show(
                            context,
                            vaultId: vault.id,
                          ),
                          child: const Text('Help Restore'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
