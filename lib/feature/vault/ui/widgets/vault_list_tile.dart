import 'package:guardian_keyper/consts.dart';
import 'package:guardian_keyper/app/routes.dart';

import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/ui/theme/brand_colors.dart';

import 'package:guardian_keyper/feature/vault/domain/entity/vault.dart';

import '../_vault_show/widgets/guardian_with_ping_tile.dart';
import '../_vault_show/widgets/page_title_restricted.dart';
import '../_vault_show/widgets/secret_list_tile.dart';
import 'guardian_list_tile.dart';

class VaultListTile extends StatelessWidget {
  const VaultListTile({
    required this.vault,
    this.initiallyExpanded = false,
    super.key,
  });

  final Vault vault;
  final bool initiallyExpanded;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brandColors = theme.extension<BrandColors>()!;
    final restrictedStyle = TextStyle(color: brandColors.dangerColor);

    return Stack(
      alignment: Alignment.topRight,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            borderRadius:
                const BorderRadius.all(Radius.circular(kCornerRadius)),
            color: theme.colorScheme.surface,
          ),
          child: ExpansionTile(
            key: PageStorageKey(vault.id.name),
            initiallyExpanded: initiallyExpanded,
            title: Text(vault.id.name),
            subtitle: vault.isRestricted
                ? (vault.hasQuorum
                    ? Text('Restricted usage', style: restrictedStyle)
                    : Text('Complete the Recovery', style: restrictedStyle))
                : (vault.isFull
                    ? Text(
                        '${vault.size} Guardians, ${vault.secrets.length} Secrets',
                      )
                    : Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 6),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.info,
                                  color: theme
                                      .extension<BrandColors>()!
                                      .warningColor,
                                  size: 16),
                              Text(' Add ${vault.maxSize - vault.size} more'
                                  '${vault.maxSize - vault.size == 1 ? ' Guardian' : ' Guardians'}'),
                            ],
                          ),
                        ],
                      )),
            trailing: null,
            childrenPadding: EdgeInsets.zero,
            children: [
              const Divider(
                height: 1,
              ),
              Column(
                children: [
                  if (vault.isFull) ...[
                    for (final secretId in vault.secrets.keys)
                      SecretListTile(vault: vault, secretId: secretId),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: ListTile(
                        title: FilledButton.icon(
                          onPressed: () => Navigator.of(context).pushNamed(
                            routeVaultSecretAdd,
                            arguments: vault.id,
                          ),
                          icon: const Icon(
                            Icons.add_circle,
                          ),
                          label: const Text(
                            'Add a Secret',
                          ),
                        ),
                      ),
                    ),
                  ],
                  if (vault.isNotFull) ...[
                    if (vault.isRestricted)
                      PageTitleRestricted(vault: vault)
                    else
                      for (final guardian in vault.guardians.keys)
                        guardian == vault.ownerId
                            ? const GuardianListTile.my()
                            : GuardianWithPingTile(guardian: guardian),
                    ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          title: FilledButton.icon(
                            onPressed: () => vault.isRestricted
                                ? Navigator.of(context)
                                    .pushNamed(routeVaultRestore)
                                : Navigator.of(context).pushNamed(
                                    routeVaultGuardianAdd,
                                    arguments: vault.id,
                                  ),
                            icon: const Icon(
                              Icons.add_circle,
                            ),
                            label: const Text(
                              'Add a Guardian',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ],
              ),
            ],
          ),
        ),

        //View Safe Icon
        Positioned(
          right: 48,
          top: 12,
          child: IconButton(
            icon: Icon(
              Icons.folder_open,
              color: theme.colorScheme.onSurface,
            ),
            onPressed: () => Navigator.pushNamed(
              context,
              routeVaultShow,
              arguments: vault.id,
            ),
          ),
        ),
      ],
    );
  }
}
