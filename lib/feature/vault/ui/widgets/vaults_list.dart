import 'package:guardian_keyper/app/routes.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';

import 'package:guardian_keyper/feature/vault/domain/use_case/vault_interactor.dart';

import 'vault_list_tile.dart';

class VaultsList extends StatelessWidget {
  const VaultsList({super.key});

  @override
  Widget build(BuildContext context) {
    final vaultInteractor = GetIt.I<VaultInteractor>();
    return StreamBuilder<Object>(
      stream: vaultInteractor.watch(),
      builder: (context, _) {
        final vaults = vaultInteractor.vaults.toList();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (vaults.isEmpty)
              const PageTitle(
                title: 'Welcome to Safes',
                subtitle: 'The Safes is a place where you can securely keep '
                    'your secrets such as seed phrases or passwords.',
              ),
            Padding(
              padding: paddingAll20,
              child: FilledButton(
                child: const Text('Add a new Safe'),
                onPressed: () => Navigator.pushNamed(
                  context,
                  routeVaultCreate,
                ),
              ),
            ),
            if (vaults.isNotEmpty)
              Expanded(
                child: ListView.separated(
                  padding: paddingAll20,
                  itemCount: vaults.length,
                  itemBuilder: (context, index) =>
                      VaultListTile(vault: vaults[index]),
                  separatorBuilder: (_, __) =>
                      const Padding(padding: paddingT12),
                ),
              ),
          ],
        );
      },
    );
  }
}
