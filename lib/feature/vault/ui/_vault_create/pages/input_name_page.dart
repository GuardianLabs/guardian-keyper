import 'package:guardian_keyper/consts.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';

import '../vault_create_presenter.dart';

class InputNamePage extends StatelessWidget {
  const InputNamePage({super.key});

  @override
  Widget build(BuildContext context) => Column(
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
                      BuildContext context,
                      VaultCreatePresenter presenter,
                    ) =>
                        presenter.isVaultNameTooShort,
                    builder: (
                      BuildContext context,
                      bool isGroupNameToolShort,
                      Widget? widget,
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
                                  routeVaultShow,
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
