import '/src/core/app/consts.dart';
import '/src/core/ui/widgets/common.dart';
import '/src/vaults/data/vault_repository.dart';

import '../widgets/guardians_expansion_tile.dart';
import '../widgets/secrets_panel_list.dart';

class VaultPage extends StatelessWidget {
  final VaultModel group;

  const VaultPage({super.key, required this.group});

  @override
  Widget build(BuildContext context) => ListView(
        padding: paddingAll20,
        primary: true,
        shrinkWrap: true,
        children: [
          // Title
          group.hasSecrets
              ? const PageTitle(
                  title: 'The Vault is ready to use',
                  subtitle:
                      'Add and recover Secrets with the help of your Guaridans.',
                )
              : PageTitle(
                  title: 'Add your Secret',
                  subtitle: 'In order to restore your Secret in the future '
                      'you’d have to get an approval from at least '
                      '${group.threshold} Guardians of this Vault.',
                ),
          // Action Button
          Padding(
            padding: paddingBottom32,
            child: PrimaryButton(
              text: 'Add a Secret',
              onPressed: () => Navigator.of(context).pushNamed(
                routeVaultAddSecret,
                arguments: group.id,
              ),
            ),
          ),
          // Guardians
          GuardiansExpansionTile(group: group),
          // Secrets
          if (group.hasSecrets)
            Padding(
              padding: paddingV20,
              child: Text('Secrets', style: textStylePoppins620),
            ),
          if (group.hasSecrets) SecretsPanelList(group: group),
        ],
      );
}
