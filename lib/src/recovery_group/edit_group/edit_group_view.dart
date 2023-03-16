import '/src/core/consts.dart';
import '/src/core/widgets/common.dart';
import '/src/core/model/core_model.dart';
import '/src/core/repository/repository.dart';

import 'widgets/add_guardian_widget.dart';
import 'widgets/add_first_secret_widget.dart';
import 'widgets/add_secret_widget.dart';
import 'widgets/guardians_expansion_tile.dart';
import 'widgets/remove_vault_bottom_sheet.dart';

class EditGroupView extends StatelessWidget {
  static const routeName = routeGroupEdit;

  final GroupId groupId;

  const EditGroupView({super.key, required this.groupId});

  @override
  Widget build(final BuildContext context) =>
      ValueListenableBuilder<Box<RecoveryGroupModel>>(
        valueListenable: GetIt.I<Box<RecoveryGroupModel>>().listenable(),
        builder: (context, boxRecoveryGroup, __) {
          final group = boxRecoveryGroup.get(groupId.asKey);
          // For correct animation on group delete
          if (group == null) return Scaffold(body: Container());
          return ScaffoldWidget(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                HeaderBar(
                  captionSpans: buildTextWithId(id: group.id),
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
                            PageTitle(
                              title: 'Vault recovery',
                              subtitleSpans: [
                                TextSpan(
                                  text:
                                      'Add ${group.maxSize - group.size} more Guardians ',
                                  style: textStyleSourceSansPro616Purple
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                                TextSpan(
                                  text: 'which were previously added to '
                                      'this Vault via QR Code to complete the recovery.',
                                  style: textStyleSourceSansPro416Purple,
                                ),
                              ],
                            ),
                            PrimaryButton(
                              text: 'Restore Vault',
                              onPressed: () => Navigator.of(context).pushNamed(
                                routeGroupRestoreGroup,
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
