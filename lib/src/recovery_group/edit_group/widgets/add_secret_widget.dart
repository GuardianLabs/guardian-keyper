import '/src/core/theme/theme.dart';
import '/src/core/widgets/common.dart';
import '/src/core/widgets/icon_of.dart';
import '/src/core/model/core_model.dart';

import 'add_secret_button.dart';
import 'guardians_expansion_tile.dart';

class AddSecretWidget extends StatelessWidget {
  final RecoveryGroupModel group;

  const AddSecretWidget({super.key, required this.group});

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: paddingV32,
            child: AddSecretButton(group: group),
          ),
          GuardiansExpansionTile(group: group),
          Padding(
            padding: paddingV20,
            child: Text('Secrets', style: textStylePoppins620),
          ),
          ExpansionPanelList.radio(
            dividerColor: clSurface,
            elevation: 0,
            expandedHeaderPadding: EdgeInsets.zero,
            children: [
              for (final secretId in group.secrets.keys)
                ExpansionPanelRadio(
                  backgroundColor: clSurface,
                  canTapOnHeader: true,
                  value: secretId.asKey,
                  headerBuilder: ((context, isExpanded) => Row(
                        children: [
                          Padding(
                            padding: paddingH20 + paddingV12,
                            child: const IconOf.secret(),
                          ),
                          Text(secretId.name, style: textStyleSourceSansPro614),
                        ],
                      )),
                  body: Padding(
                    padding: paddingH20 + paddingBottom20,
                    child: Column(
                      children: [
                        Text(
                          'In order to restore this Secret you have to get an approval '
                          'from at least ${group.threshold} Guardians of the Vault.',
                          style: textStyleSourceSansPro414Purple,
                        ),
                        const Padding(padding: paddingTop12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => Navigator.of(context).pushNamed(
                              '/recovery_group/recover_secret',
                              arguments: MapEntry(group.id, secretId),
                            ),
                            child: const Text('Recover my Secret'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ],
      );
}
