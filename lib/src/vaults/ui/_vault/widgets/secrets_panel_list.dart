import 'package:guardian_keyper/src/core/consts.dart';
import 'package:guardian_keyper/src/core/ui/widgets/common.dart';
import 'package:guardian_keyper/src/core/ui/widgets/icon_of.dart';

import '../presenters/vault_presenter.dart';
import '../remove_secret_dialog.dart';

class SecretsPanelList extends StatelessWidget {
  const SecretsPanelList({super.key});

  @override
  Widget build(final BuildContext context) {
    final vault = context.read<VaultPresenter>().vault;
    return ExpansionPanelList.radio(
      dividerColor: clSurface,
      elevation: 0,
      expandedHeaderPadding: EdgeInsets.zero,
      children: [
        for (final secretId in vault.secrets.keys)
          ExpansionPanelRadio(
            backgroundColor: clSurface,
            canTapOnHeader: true,
            value: secretId.asKey,
            headerBuilder: (
              final BuildContext context,
              final bool isExpanded,
            ) =>
                Row(
              children: [
                Padding(
                  padding: paddingH20 + paddingV12,
                  child: const IconOf.secret(),
                ),
                Text(
                  secretId.name,
                  style: textStyleSourceSansPro614,
                ),
              ],
            ),
            body: Padding(
              padding: paddingH20 + paddingBottom20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'In order to restore this Secret you have to get '
                    'an approval from at least ${vault.threshold} '
                    'Guardians of the Vault.',
                    style: textStyleSourceSansPro414Purple,
                  ),
                  Padding(
                    padding: paddingTop12,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pushNamed(
                        routeVaultRecoverSecret,
                        arguments: MapEntry(vault.id, secretId),
                      ),
                      child: const Text('Recover my Secret'),
                    ),
                  ),
                  Padding(
                    padding: paddingTop12,
                    child: ElevatedButton(
                      onPressed: () => RemoveSecretDialog.show(
                        context: context,
                        secretId: secretId,
                        vault: vault,
                      ),
                      style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(clRed),
                      ),
                      child: const Text('Remove'),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
