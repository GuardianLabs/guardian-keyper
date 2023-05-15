import 'package:guardian_keyper/consts.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/ui/widgets/icon_of.dart';

import '../vault_show_presenter.dart';
import '../dialogs/on_remove_secret_dialog.dart';

class SecretsPanelList extends StatelessWidget {
  const SecretsPanelList({super.key});

  @override
  Widget build(BuildContext context) {
    final vault = context.read<VaultShowPresenter>().vault;
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
            headerBuilder: (_, __) => Row(
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
                        routeVaultSecretRecovery,
                        arguments: (vaultId: vault.id, secretId: secretId),
                      ),
                      child: const Text('Recover my Secret'),
                    ),
                  ),
                  Padding(
                    padding: paddingTop12,
                    child: ElevatedButton(
                      onPressed: () => OnRemoveSecretDialog.show(
                        context,
                        vault: vault,
                        secretId: secretId,
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
