import '/src/core/di_container.dart';
import '/src/core/model/core_model.dart';
import '/src/core/theme/theme.dart';
import '/src/core/widgets/common.dart';

import '../widgets/vault_list_tile.dart';

class VaultsPage extends StatelessWidget {
  static const _textSubtitle =
      'The Vaults is a place where you can securely keep your '
      'secrets such as seed phrases or passwords.';

  const VaultsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final diContainer = context.read<DIContainer>();
    return ValueListenableBuilder<Box<RecoveryGroupModel>>(
      valueListenable: diContainer.boxRecoveryGroups.listenable(),
      builder: (_, boxRecoveryGroups, __) {
        final guardedGroups = boxRecoveryGroups.values
            .where((e) => e.ownerId == diContainer.myPeerId);
        return Column(
          children: [
            // Header
            const HeaderBar(caption: 'Vaults'),
            // Body
            if (guardedGroups.isEmpty)
              const PageTitle(
                title: 'You don’t have any Shards yet',
                subtitle: _textSubtitle,
              ),
            Container(
              color: clIndigo900,
              padding: paddingAll20,
              child: PrimaryButton(
                text: 'Add a new Vault',
                onPressed: () => Navigator.pushNamed(
                  context,
                  '/recovery_group/create',
                ),
              ),
            ),
            if (guardedGroups.isNotEmpty)
              Expanded(
                child: ListView(
                  padding: paddingH20,
                  children: [
                    for (final group in guardedGroups)
                      Padding(
                        padding: paddingV6,
                        child: VaultListTile(group: group),
                      ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}
