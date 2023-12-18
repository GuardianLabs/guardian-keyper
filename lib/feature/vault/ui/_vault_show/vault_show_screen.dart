import 'package:get_it/get_it.dart';

import 'package:guardian_keyper/app/routes.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';

import 'package:guardian_keyper/feature/vault/data/vault_repository.dart';
import 'package:guardian_keyper/feature/vault/domain/entity/vault_id.dart';
import 'package:guardian_keyper/feature/vault/domain/use_case/vault_interactor.dart';

import 'dialogs/on_vault_more_dialog.dart';
import 'widgets/guardians_expansion_tile.dart';
import 'widgets/page_title_restricted.dart';
import 'widgets/secret_list_tile.dart';

class VaultShowScreen extends StatelessWidget {
  const VaultShowScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final vaultId = ModalRoute.of(context)!.settings.arguments! as VaultId;
    final vaultInteractor = GetIt.I<VaultInteractor>();
    return ScaffoldSafe(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          HeaderBar(
            caption: vaultId.name,
            leftButton: const HeaderBarButton.back(),
            rightButton: HeaderBarButton.more(
              onPressed: () => OnVaultMoreDialog.show(
                context,
                vaultId: vaultId,
              ),
            ),
          ),
          // Body
          Expanded(
            child: StreamBuilder<VaultRepositoryEvent>(
              initialData: (
                isDeleted: false,
                key: vaultId.asKey,
                vault: vaultInteractor.getVaultById(vaultId),
              ),
              stream: vaultInteractor.watch(vaultId.asKey),
              builder: (context, snapshot) {
                final vault = snapshot.data!.vault!;
                return ListView(
                  padding: paddingAll20,
                  children: [
                    // Title
                    if (vault.isRestricted)
                      PageTitleRestricted(vault: vault)
                    else if (vault.isNotFull)
                      PageTitle(
                        title: 'Guardians',
                        subtitle: 'Adding ${vault.maxSize} Guardians '
                            'will activate your Vault, making it '
                            'ready to securely hold your Secrets.',
                      )
                    else
                      const PageTitle(title: 'Guardians'),
                    // Guardians
                    GuardiansExpansionTile(
                      vault: vault,
                      initiallyExpanded: vault.hasNoSecrets,
                    ),
                    if (vault.hasSecrets || vault.isFull)
                      Padding(
                        padding: paddingV20,
                        child: Text(
                          'Secrets',
                          style: theme.textTheme.titleLarge,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    // Button
                    if (vault.isFull)
                      Padding(
                        padding: paddingB20,
                        child: FilledButton(
                          child: const Text('Add a Secret'),
                          onPressed: () => Navigator.of(context).pushNamed(
                            routeVaultSecretAdd,
                            arguments: vault.id,
                          ),
                        ),
                      ),
                    // Secrets
                    for (final secretId in vault.secrets.keys)
                      SecretListTile(vault: vault, secretId: secretId)
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
