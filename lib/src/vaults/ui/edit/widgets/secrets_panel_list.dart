import '/src/core/app/consts.dart';
import '../../../../core/domain/entity/core_model.dart';
import '/src/core/ui/widgets/common.dart';
import '/src/core/ui/widgets/icon_of.dart';

import 'remove_secret_bottom_sheet.dart';

class SecretsPanelList extends StatelessWidget {
  final VaultModel group;

  const SecretsPanelList({super.key, required this.group});

  @override
  Widget build(BuildContext context) => ExpansionPanelList.radio(
        dividerColor: clSurface,
        elevation: 0,
        expandedHeaderPadding: EdgeInsets.zero,
        children: [
          for (final secretId in group.secrets.keys)
            ExpansionPanelRadio(
              backgroundColor: clSurface,
              canTapOnHeader: true,
              value: secretId.asKey,
              headerBuilder: ((_, isExpanded) => Row(
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
                  )),
              body: Padding(
                padding: paddingH20 + paddingBottom20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'In order to restore this Secret you have to get '
                      'an approval from at least ${group.threshold} '
                      'Guardians of the Vault.',
                      style: textStyleSourceSansPro414Purple,
                    ),
                    Padding(
                      padding: paddingTop12,
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).pushNamed(
                          routeVaultRecoverSecret,
                          arguments: MapEntry(group.id, secretId),
                        ),
                        child: const Text('Recover my Secret'),
                      ),
                    ),
                    Padding(
                      padding: paddingTop12,
                      child: ElevatedButton(
                        onPressed: () => showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (_) => RemoveSecretBottomSheet(
                            group: group,
                            secretId: secretId,
                          ),
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
