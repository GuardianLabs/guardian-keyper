import 'package:guardian_keyper/consts.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';

import '../vault_show_presenter.dart';
import '../widgets/secrets_panel_list.dart';
import '../widgets/guardians_expansion_tile.dart';

class VaultPage extends StatelessWidget {
  const VaultPage({super.key});

  @override
  Widget build(BuildContext context) {
    final vault = context.watch<VaultShowPresenter>().vault;
    return ListView(
      padding: paddingAll20,
      shrinkWrap: true,
      children: [
        // Title
        if (vault.hasSecrets)
          const PageTitle(
            title: 'The Vault is ready to use',
            subtitle:
                'Add and recover Secrets with the help of your Guaridans.',
          )
        else
          PageTitle(
            title: 'Add your Secret',
            subtitle: 'In order to restore your Secret in the future '
                'you’d have to get an approval from at least '
                '${vault.threshold} Guardians of this Vault.',
          ),
        // Action Button
        Padding(
          padding: paddingB32,
          child: PrimaryButton(
            text: 'Add a Secret',
            onPressed: () => Navigator.of(context).pushNamed(
              routeVaultSecretAdd,
              arguments: vault.id,
            ),
          ),
        ),
        // Guardians
        const GuardiansExpansionTile(),
        // Secrets
        if (vault.hasSecrets)
          Padding(
            padding: paddingV20,
            child: Text(
              'Secrets',
              style: stylePoppins620,
            ),
          ),
        if (vault.hasSecrets) const SecretsPanelList(),
      ],
    );
  }
}
