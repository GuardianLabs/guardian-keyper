import 'package:guardian_keyper/consts.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';

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
  Widget build(BuildContext context) => ListTile(
        enabled: vault.isNotRestricted,
        title: Text(secretId.name),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () => OnRemoveSecretDialog.show(
                context,
                vault: vault,
                secretId: secretId,
              ),
              icon: const Icon(Icons.delete_outlined, color: clRed),
            ),
            IconButton(
              onPressed: () => Navigator.of(context).pushNamed(
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
