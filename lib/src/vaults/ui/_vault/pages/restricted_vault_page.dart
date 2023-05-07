import 'package:guardian_keyper/src/core/consts.dart';
import 'package:guardian_keyper/src/core/ui/widgets/common.dart';
import 'package:guardian_keyper/src/core/ui/widgets/icon_of.dart';

import '../presenters/vault_presenter.dart';
import '../widgets/secrets_panel_list.dart';
import '../widgets/guardians_expansion_tile.dart';

class RestrictedVaultPage extends StatelessWidget {
  const RestrictedVaultPage({super.key});

  @override
  Widget build(final BuildContext context) {
    final vault = context.watch<VaultPresenter>().vault;
    return ListView(
      padding: paddingAll20,
      primary: true,
      shrinkWrap: true,
      children: [
        // Title
        vault.isRestricted
            ? PageTitle(
                title: 'Restricted usage',
                subtitleSpans: [
                  TextSpan(
                    text: 'You are able to recover all Secrets belonging '
                        'to this Vault, however you can’t add new ones until ',
                    style: textStyleSourceSansPro416Purple,
                  ),
                  TextSpan(
                    text: '${vault.maxSize} out of ${vault.maxSize} '
                        'Guardians are added.',
                    style: textStyleSourceSansPro616Purple.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )
            : PageTitle(
                title: 'Complete the recovery',
                subtitleSpans: [
                  TextSpan(
                    // TBD: i18n
                    text: 'Add ${vault.missed} more Guardian(s) ',
                    style: textStyleSourceSansPro616Purple.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: 'which were previously added to this '
                        'Vault via QR Code to complete the recovery.',
                    style: textStyleSourceSansPro416Purple,
                  ),
                ],
              ),
        // Action Button
        Padding(
          padding: paddingBottom32,
          child: PrimaryButton(
            text: 'Add a Guardian',
            onPressed: () => Navigator.of(context).pushNamed(
              routeVaultRestore,
              arguments: false,
            ),
          ),
        ),
        // Guardians
        const GuardiansExpansionTile(),
        // Secrets
        if (vault.hasSecrets) ...[
          Padding(
            padding: paddingV20,
            child: Text(
              'Secrets',
              style: textStylePoppins620,
            ),
          ),
          if (vault.hasQuorum)
            const SecretsPanelList()
          else ...[
            Padding(
              padding: paddingBottom20,
              child: Text(
                'Complete the recovery to gain access to Vault’s secrets.',
                style: textStyleSourceSansPro416Purple,
              ),
            ),
            for (final secretId in vault.secrets.keys)
              Padding(
                padding: paddingV6,
                child: ListTile(
                  enabled: false,
                  leading: const IconOf.secret(),
                  title: Text(
                    secretId.name,
                    style: textStyleSourceSansPro614,
                  ),
                ),
              ),
          ],
        ],
      ],
    );
  }
}
