import '/src/core/ui/widgets/common.dart';
import '/src/core/data/core_model.dart';

import 'guardian_with_ping_tile.dart';
import '../../../widgets/guardian_self_list_tile.dart';

class GuardiansExpansionTile extends StatelessWidget {
  const GuardiansExpansionTile({super.key, required this.group});

  final VaultModel group;

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
                : GuardianWithPingTile(guardian: guardian),
        ],
      );
}
