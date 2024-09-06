import 'package:guardian_keyper/app/routes.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';

import 'package:guardian_keyper/feature/vault/domain/use_case/vault_interactor.dart';

import 'vault_list_tile.dart';

class VaultsList extends StatelessWidget {
  const VaultsList({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final vaultInteractor = GetIt.I<VaultInteractor>();

    return StreamBuilder<Object>(
      stream: vaultInteractor.watch(),
      builder: (context, _) {
        final vaults = vaultInteractor.vaults.toList();
        return Padding(
          padding: paddingAllDefault,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: vaults.isEmpty
                    ? const Center(
                        child: PageTitle(
                          title: 'There will be your Safes',
                          subtitle: 'A Safe is a secure place to store '
                              'your secrets, such as seed phrases or passwords.',
                        ),
                      )
                    : ListView.separated(
                        separatorBuilder: (_, __) =>
                            const Padding(padding: paddingT12),
                        itemCount: vaults.length,
                        itemBuilder: (context, index) => VaultListTile(
                          vault: vaults[index],
                          initiallyExpanded: index == 0,
                        ),
                      ),
              ),

              //Buttons
              const Padding(padding: paddingTDefault),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.add_circle,
                          size: 48,
                          color: theme.colorScheme.primary,
                        ),
                        onPressed: () =>
                            Navigator.of(context).pushNamed(routeVaultCreate),
                        padding: EdgeInsets.zero,
                      ),
                      const Padding(
                        padding: paddingT12,
                        child: Text('New Safe'),
                      )
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.replay,
                          color: theme.colorScheme.primary,
                          size: 48,
                        ),
                        onPressed: () =>
                            Navigator.of(context).pushNamed(routeVaultRestore),
                        padding: EdgeInsets.zero,
                      ),
                      const Padding(
                        padding: paddingT12,
                        child: Text('Restore a Safe'),
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
