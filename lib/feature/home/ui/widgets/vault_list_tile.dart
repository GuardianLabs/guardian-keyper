import 'package:guardian_keyper/consts.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';

import 'package:guardian_keyper/feature/vault/domain/entity/vault.dart';

class VaultListTile extends StatelessWidget {
  const VaultListTile({
    required this.vault,
    super.key,
  });

  final Vault vault;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brandColors = theme.extension<BrandColors>()!;
    final restrictedStyle = TextStyle(color: brandColors.dangerColor);
    return ListTile(
      leading: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.secondary,
          shape: BoxShape.circle,
        ),
        height: 40,
        width: 40,
        child: const Icon(Icons.shield_outlined),
      ),
      title: Text(vault.id.name),
      subtitle: vault.isRestricted
          ? (vault.hasQuorum
              ? Text('Restricted usage', style: restrictedStyle)
              : Text('Complete the Recovery', style: restrictedStyle))
          : (vault.isFull
              ? Text(
                  '${vault.size} Guardians, ${vault.secrets.length} Secrets',
                )
              : Text('Add more Guardians', style: restrictedStyle)),
      trailing: Icon(
        Icons.arrow_forward_ios_rounded,
        color: theme.colorScheme.onPrimary,
      ),
      onTap: () => Navigator.pushNamed(
        context,
        routeVaultShow,
        arguments: vault.id,
      ),
    );
  }
}
