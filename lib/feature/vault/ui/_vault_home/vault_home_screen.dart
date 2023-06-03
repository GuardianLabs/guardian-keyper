import 'package:guardian_keyper/consts.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';

import 'vault_home_presenter.dart';
import 'widgets/vault_list_tile.dart';

class VaultHomeScreen extends StatelessWidget {
  const VaultHomeScreen({super.key});

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        key: const Key('VaultHomePresenter'),
        create: (_) => VaultHomePresenter(),
        child: Consumer<VaultHomePresenter>(
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
