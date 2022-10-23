import '/src/core/di_container.dart';
import '/src/core/theme/theme.dart';
import '/src/core/widgets/common.dart';
import '/src/core/model/core_model.dart';

import 'widgets/add_guardian_widget.dart';
import 'widgets/add_first_secret_widget.dart';
import 'widgets/add_secret_widget.dart';
import 'widgets/guardians_expansion_tile.dart';
import 'widgets/remove_vault_bottom_sheet.dart';

class RecoveryGroupEditView extends StatelessWidget {
  static const routeName = '/recovery_group/edit';

  final GroupId groupId;

  const RecoveryGroupEditView({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) =>
      ValueListenableBuilder<Box<RecoveryGroupModel>>(
        valueListenable:
            context.read<DIContainer>().boxRecoveryGroups.listenable(),
        builder: (context, boxRecoveryGroup, __) {
          final group = boxRecoveryGroup.get(groupId.asKey);
          return ScaffoldWidget(
            child: group == null // For correct animation on group delete
                ? Container()
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header
                      HeaderBar(
                        caption: group.id.nameEmoji,
                        backButton: const HeaderBarBackButton(),
                        closeButton: HeaderBarMoreButton(
                          onPressed: () => showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (_) => RemoveVaultBottomSheet(
                              group: group,
                            ),
                          ),
                        ),
                      ),
                      // Body
                      Expanded(
                        child: ListView(
                          padding: paddingAll20,
                          primary: true,
                          shrinkWrap: true,
                          children: group.isRestoring
                              ? [
                                  const PageTitle(
                                    title: 'Vault is not restored yet',
                                    subtitle:
                                        'Please, restore membership of other Guardians',
                                  ),
                                  PrimaryButton(
                                    text: 'Restore Vault',
                                    onPressed: () =>
                                        Navigator.of(context).pushNamed(
                                      '/recovery_group/restore',
                                      arguments: false,
                                    ),
                                  ),
                                  const Padding(padding: paddingTop32),
                                  GuardiansExpansionTile(group: group),
                                ]
                              : [
                                  // Group is not complited, can add guardian to group
                                  if (group.isNotFull && group.isNotRestoring)
                                    AddGuardianWidget(group: group),
                                  // Group is complited, can add secret
                                  if (group.isFull)
                                    group.secrets.isEmpty
                                        ? AddFirstSecretWidget(group: group)
                                        : AddSecretWidget(group: group),
                                ],
                        ),
                      ),
                    ],
                  ),
          );
        },
      );
}
