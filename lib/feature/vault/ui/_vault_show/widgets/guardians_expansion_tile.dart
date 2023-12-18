import 'package:guardian_keyper/consts.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';

import 'package:guardian_keyper/feature/vault/domain/entity/vault.dart';
import 'package:guardian_keyper/feature/vault/ui/widgets/guardian_list_tile.dart';

import 'guardian_with_ping_tile.dart';

class GuardiansExpansionTile extends StatelessWidget {
  const GuardiansExpansionTile({
    required this.vault,
    this.initiallyExpanded = false,
    super.key,
  });

  final Vault vault;
  final bool initiallyExpanded;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ExpansionTile(
      initiallyExpanded: initiallyExpanded,
      childrenPadding: EdgeInsets.zero,
      title: Text(
        'Vault’s Guardians',
        style: theme.textTheme.bodyMedium,
      ),
      subtitle: vault.isFull
          ? Text(
              '${vault.size} out of ${vault.maxSize}',
              style: theme.textTheme.bodySmall,
            )
          : Row(
              children: [
                const Icon(Icons.info, color: Colors.orange, size: 16),
                Text(
                  '  ${vault.size} out of ${vault.maxSize}',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
      children: [
        for (final guardian in vault.guardians.keys)
          guardian == vault.ownerId
              ? const GuardianListTile.my()
              : GuardianWithPingTile(guardian: guardian),
        for (var i = vault.size; i < vault.maxSize; i++)
          GuardianListTile.empty(
            onTap: () => vault.isRestricted
                ? Navigator.of(context).pushNamed(routeVaultRestore)
                : Navigator.of(context).pushNamed(
                    routeVaultGuardianAdd,
                    arguments: vault.id,
                  ),
          ),
      ],
    );
  }
}
