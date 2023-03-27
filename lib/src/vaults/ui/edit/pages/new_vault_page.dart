import '/src/core/consts.dart';
import '/src/core/ui/widgets/common.dart';
import '/src/core/data/repository_root.dart';

import '../widgets/guardian_with_ping_tile.dart';

class NewVaultPage extends StatelessWidget {
  final VaultModel group;

  const NewVaultPage({super.key, required this.group});

  @override
  Widget build(BuildContext context) => ListView(
        padding: paddingAll20,
        primary: true,
        shrinkWrap: true,
        children: [
          PageTitle(
            title: 'Add more Guardians',
            subtitleSpans: [
              TextSpan(
                text: 'Add ${group.maxSize - group.size} more Guardians ',
                style: textStyleSourceSansPro616Purple.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: 'to enable your Vault and secure your Secret.',
                style: textStyleSourceSansPro416Purple,
              ),
            ],
          ),
          Padding(
            padding: paddingBottom32,
            child: PrimaryButton(
              text: 'Add a Guardian',
              onPressed: () => Navigator.of(context).pushNamed(
                routeVaultAddGuardian,
                arguments: group.id,
              ),
            ),
          ),
          for (final guardian in group.guardians.keys)
            Padding(
              padding: paddingV6,
              child: GuardianWithPingTile(guardian: guardian),
            ),
        ],
      );
}
