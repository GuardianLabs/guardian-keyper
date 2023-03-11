import '/src/core/widgets/common.dart';
import '/src/core/model/core_model.dart';

import 'guardian_tile_with_ping_widget.dart';
import '../../widgets/guardian_self_list_tile.dart';

class GuardiansExpansionTile extends StatelessWidget {
  const GuardiansExpansionTile({super.key, required this.group});

  final RecoveryGroupModel group;

  @override
  Widget build(final BuildContext context) => ExpansionTile(
        title: Text(
          'Vault’s Guardians',
          style: textStyleSourceSansPro614,
        ),
        subtitle: Text(
          '${group.size} Guardians',
          style: textStyleSourceSansPro414Purple,
        ),
        childrenPadding: EdgeInsets.zero,
        children: [
          for (final guardian in group.guardians.keys)
            guardian == group.ownerId
                ? GuardianSelfListTile(guardian: guardian)
                : GuardianTileWithPingWidget(guardian: guardian),
        ],
      );
}
