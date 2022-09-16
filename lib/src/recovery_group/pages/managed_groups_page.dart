import '/src/core/di_container.dart';
import '/src/core/model/core_model.dart';
import '/src/core/theme_data.dart';
import '/src/core/widgets/icon_of.dart';
import '/src/core/widgets/common.dart';

import '../widgets/recovery_group_tile_widget.dart';
import '../create_group/create_group_view.dart';

class ManagedGroupsPage extends StatelessWidget {
  const ManagedGroupsPage({super.key});

  @override
  Widget build(BuildContext context) =>
      ValueListenableBuilder<Box<RecoveryGroupModel>>(
          valueListenable:
              context.read<DIContainer>().boxRecoveryGroup.listenable(),
          builder: (_, boxRecoveryGroup, __) => Column(
                children: [
                  // Header
                  const HeaderBar(caption: 'My Secrets'),
                  // Body
                  if (boxRecoveryGroup.keys.isEmpty) ...[
                    const Padding(
                      padding: paddingTop32,
                      child: IconOf.secret(isBig: true),
                    ),
                    Padding(
                      padding: paddingV32,
                      child: Text(
                        'You don’t have any Secrets yet',
                        textAlign: TextAlign.center,
                        style: textStylePoppins620,
                        overflow: TextOverflow.clip,
                      ),
                    ),
                    Padding(
                      padding: paddingV32H20,
                      child: PrimaryButton(
                        text: 'Add new Group',
                        onPressed: () => Navigator.pushNamed(
                          context,
                          CreateGroupView.routeName,
                        ),
                      ),
                    ),
                  ] else
                    Expanded(
                      child: ListView(
                        padding: paddingAll20,
                        children: [
                          for (final group in boxRecoveryGroup.values)
                            Padding(
                              padding: paddingV6,
                              child: RecoveryGroupTileWidget(group: group),
                            ),
                          Padding(
                            padding: paddingV32,
                            child: PrimaryButton(
                              text: 'Add new Group',
                              onPressed: () => Navigator.pushNamed(
                                context,
                                CreateGroupView.routeName,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ));
}
