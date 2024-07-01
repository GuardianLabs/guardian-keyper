import 'package:guardian_keyper/ui/widgets/common.dart';

import '../vault_create_presenter.dart';

class ChooseSizePage extends StatelessWidget {
  const ChooseSizePage({super.key});

  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<VaultCreatePresenter>(context);
    return ScaffoldSafe(
      appBar: AppBar(
        title: const Text('How many Guardians do you need?'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      child: Column(children: [
        // Body
        Expanded(
          child: ListView(
            padding: paddingAll20,
            children: [
              // Control
              ListTile(
                title: const Text('3 Guardians'),
                subtitle: const Text(
                  'Recovering a Secret will require approval from '
                  'at least 2 out of 3 Guardians.',
                ),
                trailing: Icon(
                  presenter.vaultSize == 3
                      ? Icons.radio_button_on
                      : Icons.radio_button_off,
                ),
                onTap: () => presenter.setVaultSize(3, 2),
              ),
              const Padding(padding: paddingB12),
              ListTile(
                title: const Text('5 Guardians'),
                subtitle: const Text(
                  'Recovering a Secret will require approval from '
                  'at least 3 out of 5 Guardians.',
                ),
                trailing: Icon(
                  presenter.vaultSize == 5
                      ? Icons.radio_button_on
                      : Icons.radio_button_off,
                ),
                onTap: () => presenter.setVaultSize(5, 3),
              ),
              const Padding(padding: EdgeInsets.only(bottom: 32)),
              ListTile(
                isThreeLine: true,
                title: const Text('Turn this device into a Guardian'),
                subtitle: const Text(
                  'The device will count as one Guardian. It will keep parts '
                  'of Secrets and automatically give an approval '
                  'during the Secret recovery.',
                ),
                trailing: Icon(
                  presenter.isVaultMember
                      ? Icons.check_box
                      : Icons.check_box_outline_blank,
                ),
                onTap: presenter.toggleVaultMembership,
              ),
              // Footer
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: FilledButton(
                  onPressed: context.read<VaultCreatePresenter>().nextPage,
                  child: const Text('Continue'),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
