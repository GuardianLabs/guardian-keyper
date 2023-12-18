import 'package:guardian_keyper/consts.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/ui/theme/brand_colors.dart';

import 'package:guardian_keyper/feature/vault/domain/entity/vault.dart';
import 'package:guardian_keyper/feature/vault/domain/entity/secret_id.dart';
import 'package:guardian_keyper/feature/vault/ui/_vault_show/dialogs/on_remove_secret_dialog.dart';

class SecretListTile extends StatelessWidget {
  const SecretListTile({
    required this.secretId,
    required this.vault,
    super.key,
  });

  final Vault vault;
  final SecretId secretId;

  @override
  Widget build(BuildContext context) {
    final dangerColor = Theme.of(context).extension<BrandColors>()!.dangerColor;
    return ListTile(
      title: Text(secretId.name),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: vault.isRestricted
                ? null
                : () => OnRemoveSecretDialog.show(
                      context,
                      vault: vault,
                      secretId: secretId,
                    ),
            icon: Icon(
              Icons.delete_outlined,
              color: vault.isRestricted
                  ? dangerColor.withOpacity(0.5)
                  : dangerColor,
            ),
          ),
          IconButton(
            onPressed: vault.isRestricted
                ? null
                : () => Navigator.of(context).pushNamed(
                      routeVaultSecretRecovery,
                      arguments: (
                        vaultId: vault.id,
                        secretId: secretId,
                      ),
                    ),
            icon: const Icon(Icons.visibility_outlined),
          ),
        ],
      ),
    );
  }
}
