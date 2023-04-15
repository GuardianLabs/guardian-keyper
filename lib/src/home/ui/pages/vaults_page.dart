import '/src/core/app/consts.dart';
import '/src/core/ui/widgets/common.dart';

import '../home_presenter.dart';
import '../widgets/vault_list_tile.dart';

class VaultsPage extends StatelessWidget {
  const VaultsPage({super.key});

  @override
  Widget build(final BuildContext context) => Consumer<HomePresenter>(
        builder: (context, presenter, __) => Column(
          children: [
            // Header
            const HeaderBar(caption: 'Vaults'),
            // Body
            if (presenter.myVaults.isEmpty)
              const PageTitle(
                title: 'Welcome to Vaults',
                subtitle: 'The Vaults is a place where you can securely keep '
                    'your secrets such as seed phrases or passwords.',
              ),
            Container(
              color: clIndigo900,
              padding: paddingAll20,
              child: PrimaryButton(
                text: 'Add a new Vault',
                onPressed: () => Navigator.pushNamed(context, routeVaultCreate),
              ),
            ),
            if (presenter.myVaults.isNotEmpty)
              Expanded(
                child: ListView(
                  padding: paddingH20,
                  children: [
                    for (final group in presenter.myVaults.values)
                      Padding(
                        padding: paddingV6,
                        child: VaultListTile(group: group),
                      ),
                  ],
                ),
              ),
          ],
        ),
      );
}
