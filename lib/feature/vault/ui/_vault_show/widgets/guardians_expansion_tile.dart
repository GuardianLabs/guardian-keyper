import 'package:guardian_keyper/app/routes.dart';
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
  Widget build(BuildContext context) => ExpansionTile(
        initiallyExpanded: initiallyExpanded,
        childrenPadding: EdgeInsets.zero,
        title: const Text('Vault’s Guardians'),
        subtitle: vault.isFull
            ? Text('${vault.size} out of ${vault.maxSize}')
            : Row(
                children: [
                  const Icon(Icons.info, color: Colors.orange, size: 16),
                  Text('  ${vault.size} out of ${vault.maxSize}'),
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
