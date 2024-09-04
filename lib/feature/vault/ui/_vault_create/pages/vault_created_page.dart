import 'package:guardian_keyper/app/routes.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';

import '../vault_create_presenter.dart';

class VaultCreatedPage extends StatelessWidget {
  const VaultCreatedPage({super.key});

  @override
  Widget build(BuildContext context) => Padding(
        padding: paddingAllDefault,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //Body
            const Spacer(),
            const Icon(Icons.check_circle, size: 64),
            const PageTitle(
              title: 'Safe Created!',
              subtitle:
                  'Your Safe is now set up. Next, add Guardians to ensure '
                  'your Safe`s security and recovery.',
            ),
            const Spacer(),
            // Footer
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: FilledButton(
                onPressed: () => Navigator.popAndPushNamed(
                  context,
                  routeVaultShow,
                  arguments: context.read<VaultCreatePresenter>().vault.id,
                ),
                child: const Text('Go to Safe'),
              ),
            ),
          ],
        ),
      );
}
