import '/src/core/consts.dart';
import '/src/core/ui/widgets/common.dart';
import '/src/core/data/core_model.dart';

import '../vault_create_presenter.dart';

class InputNamePage extends StatelessWidget {
  const InputNamePage({super.key});

  @override
  Widget build(final BuildContext context) {
    final controller = context.read<VaultCreatePresenter>();
    return Column(
      children: [
        // Header
        HeaderBar(
          caption: 'Name the Vault',
          backButton: HeaderBarBackButton(onPressed: controller.previousScreen),
          closeButton: const HeaderBarCloseButton(),
        ),
        // Body
        Expanded(
          child: ListView(
            padding: paddingH20,
            children: [
              const PageTitle(title: 'Create a name for your Vault'),
              TextFormField(
                autofocus: true,
                keyboardType: TextInputType.text,
                maxLength: IdBase.maxNameLength,
                decoration: const InputDecoration(labelText: ' Vault name '),
                onChanged: (value) => controller.groupName = value,
              ),
              // Footer
              Padding(
                padding: paddingV32,
                child: Selector<VaultCreatePresenter, bool>(
                  selector: (_, controller) => controller.isGroupNameToolShort,
                  builder: (_, isGroupNameToolShort, __) => PrimaryButton(
                    text: 'Continue',
                    onPressed: isGroupNameToolShort
                        ? null
                        : () => controller.createVault().then(
                              (vault) => Navigator.popAndPushNamed(
                                context,
                                routeVaultEdit,
                                arguments: vault.id,
                              ),
                            ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
