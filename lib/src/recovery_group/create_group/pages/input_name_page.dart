import '/src/core/theme/theme.dart';
import '/src/core/widgets/common.dart';

import '../create_group_controller.dart';

class InputNamePage extends StatelessWidget {
  const InputNamePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<CreateGroupController>(context);
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
                maxLength: controller.diContainer.globals.maxNameLength,
                decoration: const InputDecoration(labelText: ' Vault name '),
                onChanged: (value) => controller.groupName = value,
              ),
              // Footer
              Padding(
                padding: paddingV32,
                child: PrimaryButton(
                  text: 'Continue',
                  onPressed: controller.groupName.isEmpty
                      ? null
                      : () => controller.createVault().then(
                            (vault) => Navigator.popAndPushNamed(
                              context,
                              '/recovery_group/edit',
                              arguments: vault.id,
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
