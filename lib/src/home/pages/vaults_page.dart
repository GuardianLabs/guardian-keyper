import '/src/core/consts.dart';
import '/src/core/widgets/common.dart';

import '../home_controller.dart';
import '../widgets/vault_list_tile.dart';

class VaultsPage extends StatelessWidget {
  const VaultsPage({super.key});

  @override
  Widget build(final BuildContext context) {
    final myVaults = context.watch<HomeController>().myVaults;
    return Column(
      children: [
        // Header
        const HeaderBar(caption: 'Vaults'),
        // Body
        if (myVaults.isEmpty)
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
            onPressed: () => Navigator.pushNamed(context, routeGroupCreate),
          ),
        ),
        if (myVaults.isNotEmpty)
          Expanded(
            child: ListView(
              padding: paddingH20,
              children: [
                for (final group in myVaults.values)
                  Padding(
                    padding: paddingV6,
                    child: VaultListTile(group: group),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}
