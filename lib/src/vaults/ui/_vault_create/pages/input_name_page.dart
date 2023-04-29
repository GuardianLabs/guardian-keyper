import 'package:guardian_keyper/src/core/consts.dart';
import 'package:guardian_keyper/src/core/ui/widgets/common.dart';

import '../presenters/vault_create_presenter.dart';

class InputNamePage extends StatelessWidget {
  const InputNamePage({super.key});

  @override
  Widget build(final BuildContext context) => Column(
        children: [
          // Header
          HeaderBar(
            caption: 'Name the Vault',
            backButton: HeaderBarBackButton(
              onPressed: context.read<VaultCreatePresenter>().previousPage,
            ),
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
                  maxLength: maxNameLength,
                  decoration: const InputDecoration(labelText: ' Vault name '),
                  onChanged: context.read<VaultCreatePresenter>().setVaultName,
                ),
                // Footer
                Padding(
                  padding: paddingV32,
                  child: Selector<VaultCreatePresenter, bool>(
                    selector: (
                      final BuildContext context,
                      final VaultCreatePresenter presenter,
                    ) =>
                        presenter.isVaultNameTooShort,
                    builder: (
                      final BuildContext context,
                      final bool isGroupNameToolShort,
                      final Widget? widget,
                    ) =>
                        PrimaryButton(
                      text: 'Continue',
                      onPressed: isGroupNameToolShort
                          ? null
                          : () async {
                              final vault = await context
                                  .read<VaultCreatePresenter>()
                                  .createVault();
                              if (context.mounted) {
                                Navigator.popAndPushNamed(
                                  context,
                                  routeVaultEdit,
                                  arguments: vault.id,
                                );
                              }
                            },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
}
