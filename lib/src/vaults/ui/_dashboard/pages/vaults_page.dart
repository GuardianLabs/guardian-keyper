import 'package:guardian_keyper/src/core/consts.dart';
import 'package:guardian_keyper/src/core/ui/widgets/common.dart';

import '../presenters/vaults_presenter.dart';
import '../widgets/vault_list_tile.dart';

class VaultsPage extends StatelessWidget {
  const VaultsPage({super.key});

  @override
  Widget build(final BuildContext context) => ChangeNotifierProvider(
        create: (final BuildContext context) => VaultsPresenter(),
        child: Consumer<VaultsPresenter>(
          builder: (
            final BuildContext context,
            final VaultsPresenter presenter,
            final Widget? widget,
          ) =>
              Column(
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
                padding: paddingV20,
                child: PrimaryButton(
                  text: 'Add a new Vault',
                  onPressed: () =>
                      Navigator.pushNamed(context, routeVaultCreate),
                ),
              ),
              if (presenter.myVaults.isNotEmpty)
                Expanded(
                  child: ListView(
                    children: [
                      for (final vault in presenter.myVaults.values)
                        Padding(
                          padding: paddingV6,
                          child: VaultListTile(vault: vault),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      );
}
