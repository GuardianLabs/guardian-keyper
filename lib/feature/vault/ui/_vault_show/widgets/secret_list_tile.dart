import 'package:guardian_keyper/app/routes.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/ui/theme/brand_colors.dart';
import 'package:guardian_keyper/data/repositories/settings_repository.dart';

import 'package:guardian_keyper/feature/vault/domain/entity/vault.dart';
import 'package:guardian_keyper/feature/vault/domain/entity/secret_id.dart';
import 'package:guardian_keyper/feature/vault/ui/_vault_show/dialogs/on_remove_secret_dialog.dart';

import '../dialogs/on_secret_restore_dialog.dart';

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
                : () async {
                    final isSecretRestoreExplainerHidden =
                        GetIt.I<SettingsRepository>().get<bool>(
                                SettingsRepositoryKeys
                                    .keyIsSecretRestoreExplainerHidden) ??
                            false;
                    if (!isSecretRestoreExplainerHidden) {
                      final shouldContinue =
                          await OnSecretRestoreDialog.show(context) ?? false;
                      if (!shouldContinue) return;
                    }
                    if (context.mounted) {
                      Navigator.of(context).pushNamed(
                        routeVaultSecretRecovery,
                        arguments: (
                          vaultId: vault.id,
                          secretId: secretId,
                        ),
                      );
                    }
                  },
            icon: const Icon(Icons.visibility_outlined),
          ),
        ],
      ),
    );
  }
}
