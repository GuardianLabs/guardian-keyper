import '/src/core/consts.dart';
import '/src/core/widgets/common.dart';
import '/src/core/repository/repository_root.dart';
import '/src/guardian/guardian_controller.dart';

import '../widgets/vault_list_tile.dart';

class VaultsPage extends StatelessWidget {
  const VaultsPage({super.key});

  @override
  Widget build(final BuildContext context) =>
      ValueListenableBuilder<Box<RecoveryGroupModel>>(
        valueListenable: GetIt.I<RepositoryRoot>().vaultRepository.listenable(),
        builder: (_, boxRecoveryGroups, __) {
          final myId = GetIt.I<GuardianController>().state;
          final guardedGroups =
              boxRecoveryGroups.values.where((e) => e.ownerId == myId);
          return Column(
            children: [
              // Header
              const HeaderBar(caption: 'Vaults'),
              // Body
              if (guardedGroups.isEmpty)
                const PageTitle(
                  title: 'You don’t have any Shards yet',
                  subtitle: 'The Vaults is a place where you can securely keep '
                      'your secrets such as seed phrases or passwords.',
                ),
              Container(
                color: clIndigo900,
                padding: paddingAll20,
                child: PrimaryButton(
                  text: 'Add a new Vault',
                  onPressed: () =>
                      Navigator.pushNamed(context, routeGroupCreate),
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
