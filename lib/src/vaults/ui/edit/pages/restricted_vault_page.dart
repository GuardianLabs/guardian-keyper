import '/src/core/app/consts.dart';
import '/src/core/ui/widgets/common.dart';
import '/src/core/ui/widgets/icon_of.dart';
import '/src/vaults/data/vault_repository.dart';

import '../widgets/guardians_expansion_tile.dart';
import '../widgets/secrets_panel_list.dart';

class RestrictedVaultPage extends StatelessWidget {
  final VaultModel group;

  const RestrictedVaultPage({super.key, required this.group});

  @override
  Widget build(BuildContext context) => ListView(
        padding: paddingAll20,
        primary: true,
        shrinkWrap: true,
        children: [
          // Title
          group.isRestricted
              ? PageTitle(
                  title: 'Restricted usage',
                  subtitleSpans: [
                    TextSpan(
                      text: 'You are able to recover all Secrets belonging '
                          'to this Vault, however you can’t add new ones until ',
                      style: textStyleSourceSansPro416Purple,
                    ),
                    TextSpan(
                      text: '${group.maxSize} out of ${group.maxSize} '
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
                      text: 'Add ${group.missed} more Guardian(s) ',
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
          GuardiansExpansionTile(group: group),
          // Secrets
          if (group.hasSecrets) ...[
            Padding(
              padding: paddingV20,
              child: Text(
                'Secrets',
                style: textStylePoppins620,
              ),
            ),
            if (group.hasQuorum)
              SecretsPanelList(group: group)
            else ...[
              Padding(
                padding: paddingBottom20,
                child: Text(
                  'Complete the recovery to gain access to Vault’s secrets.',
                  style: textStyleSourceSansPro416Purple,
                ),
              ),
              // TBD: make them disabled
              for (final secretId in group.secrets.keys)
                Padding(
                  padding: paddingV6,
                  child: ListTile(
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
