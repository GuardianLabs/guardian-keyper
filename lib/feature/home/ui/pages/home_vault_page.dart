import 'package:get_it/get_it.dart';

import 'package:guardian_keyper/app/routes.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/ui/utils/screen_size.dart';

import 'package:guardian_keyper/feature/home/ui/widgets/vault_list_tile.dart';
import 'package:guardian_keyper/feature/vault/domain/use_case/vault_interactor.dart';

class HomeVaultsPage extends StatelessWidget {
  const HomeVaultsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final vaultInteractor = GetIt.I<VaultInteractor>();
    final isTitleVisible =
        MediaQuery.of(context).size.height >= ScreenMedium.height;
    return StreamBuilder<Object>(
      stream: vaultInteractor.watch(),
      builder: (context, snapshot) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          if (isTitleVisible) const HeaderBar(caption: 'Vaults'),
          // Body
          if (vaultInteractor.vaults.isEmpty)
            const PageTitle(
              title: 'Welcome to Vaults',
              subtitle: 'The Vaults is a place where you can securely keep '
                  'your secrets such as seed phrases or passwords.',
            ),
          Padding(
            padding: paddingV20,
            child: FilledButton(
              child: const Text('Add a new Vault'),
              onPressed: () => Navigator.pushNamed(
                context,
                routeVaultCreate,
              ),
            ),
          ),
          if (vaultInteractor.vaults.isNotEmpty)
            Expanded(
              child: ListView(
                children: [
                  for (final vault in vaultInteractor.vaults)
                    Padding(
                      padding: paddingV6,
                      child: VaultListTile(vault: vault),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
