import 'package:guardian_keyper/consts.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';

import '../vault_create_presenter.dart';

class VaultCreatedPage extends StatelessWidget {
  const VaultCreatedPage({super.key});

  @override
  Widget build(BuildContext context) => Padding(
        padding: paddingAll20,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //Body
            const Spacer(),
            const Icon(Icons.check_circle, size: 64),
            const PageTitle(
              title: 'Vault Created!',
              subtitle:
                  'Your vault is now set up. Next, add Guardians to ensure '
                  'your Vault`s security and recovery.',
            ),
            const Spacer(),
            // Footer
            Padding(
              padding: paddingV32,
              child: FilledButton(
                onPressed: () => Navigator.popAndPushNamed(
                  context,
                  routeVaultShow,
                  arguments: context.read<VaultCreatePresenter>().vault.id,
                ),
                child: const Text('Go to Vault'),
              ),
            ),
          ],
        ),
      );
}
