import '/src/core/theme/theme.dart';
import '/src/core/widgets/common.dart';
import '/src/settings/settings_model.dart';

import '../create_group_controller.dart';

class InputNamePage extends StatelessWidget {
  const InputNamePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<CreateGroupController>();
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
                maxLength: SettingsModel.maxNameLength,
                decoration: const InputDecoration(labelText: ' Vault name '),
                onChanged: (value) => controller.groupName = value,
              ),
              // Footer
              Padding(
                padding: paddingV32,
                child: Selector<CreateGroupController, bool>(
                  selector: (_, controller) => controller.isGroupNameToolShort,
                  builder: (_, isGroupNameToolShort, __) => PrimaryButton(
                    text: 'Continue',
                    onPressed: isGroupNameToolShort
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
              ),
            ],
          ),
        ),
      ],
    );
  }
}
