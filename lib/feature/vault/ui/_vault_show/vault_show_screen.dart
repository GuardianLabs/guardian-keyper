import 'package:guardian_keyper/consts.dart';
import 'package:guardian_keyper/app/routes.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';

import 'package:guardian_keyper/feature/vault/domain/entity/vault.dart';
import 'package:guardian_keyper/feature/vault/domain/entity/vault_id.dart';
import 'package:guardian_keyper/feature/vault/domain/use_case/vault_interactor.dart';

import 'dialogs/on_vault_more_dialog.dart';
import 'widgets/guardians_expansion_tile.dart';
import 'widgets/page_title_restricted.dart';
import 'widgets/secret_list_tile.dart';

class VaultShowScreen extends StatelessWidget {
  static const route = '/vault/show';

  const VaultShowScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vaultId = ModalRoute.of(context)!.settings.arguments! as VaultId;
    final vaultInteractor = GetIt.I<VaultInteractor>();
    return ScaffoldSafe(
      appBar: AppBar(
        title: Text(vaultId.name),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              OnVaultMoreDialog.show(
                context,
                vaultId: vaultId,
              );
            },
          ),
        ],
      ),
      child: StreamBuilder<VaultRepositoryEvent>(
        initialData: (
          isDeleted: false,
          key: vaultId.asKey,
          vault: vaultInteractor.getVaultById(vaultId),
        ),
        stream: vaultInteractor.watch(vaultId.asKey),
        builder: (context, snapshot) {
          final vault = snapshot.data?.vault ??
              Vault(
                ownerId: vaultInteractor.selfId,
              );
          return ListView(
            padding: paddingHDefault,
            children: [
              // Button
              if (vault.isFull)
                Padding(
                  padding: paddingBDefault,
                  child: FilledButton(
                    child: const Text('Add a Secret'),
                    onPressed: () => Navigator.of(context).pushNamed(
                      routeVaultSecretAdd,
                      arguments: vault.id,
                    ),
                  ),
                ),
              // Secrets
              if (vault.hasSecrets)
                const Padding(
                  padding: paddingV4,
                  child: Text('Safe’s Secrets:'),
                ),
              DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(kCornerRadius),
                  ),
                  color: Theme.of(context).colorScheme.surface,
                ),
                child: Column(
                  children: [
                    for (final secretId in vault.secrets.keys)
                      SecretListTile(vault: vault, secretId: secretId),
                  ],
                ),
              ),
              // Guardians
              if (vault.isRestricted)
                PageTitleRestricted(vault: vault)
              else if (vault.isNotFull)
                PageTitle(
                  subtitle: 'Adding ${vault.maxSize} Guardians '
                      'will activate your Safe, making it '
                      'ready to securely hold your Secrets.',
                )
              else ...[
                const Padding(padding: paddingTDefault),
                const Padding(
                  padding: paddingV4,
                  child: Text('Safe’s Guardians:'),
                ),
              ],
              // Guardians List
              Column(
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(kCornerRadius),
                      ),
                      color: Theme.of(context).colorScheme.surface,
                    ),
                    child: GuardiansExpansionTile(
                      vault: vault,
                      initiallyExpanded: vault.hasNoSecrets,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
