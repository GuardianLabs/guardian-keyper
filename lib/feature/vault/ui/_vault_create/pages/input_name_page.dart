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
            caption: 'Name the Safe',
            leftButton: HeaderBarButton.back(
              onPressed: context.read<VaultCreatePresenter>().previousPage,
            ),
            rightButton: const HeaderBarButton.close(),
          ),
          // Body
          Expanded(
            child: ListView(
              padding: paddingH20,
              children: [
                const PageTitle(title: 'Create a Name for your Safe'),
                TextField(
                  autofocus: true,
                  keyboardType: TextInputType.text,
                  maxLength: maxNameLength,
                  decoration: const InputDecoration(
                    labelText: ' Safe name ',
                  ),
                  onTapOutside: (_) => FocusScope.of(context).unfocus(),
                  onChanged: context.read<VaultCreatePresenter>().setVaultName,
                ),
                // Footer
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Selector<VaultCreatePresenter, bool>(
                    selector: (context, presenter) =>
                        presenter.isVaultNameTooShort,
                    builder: (context, isGroupNameToolShort, _) => FilledButton(
                      onPressed: isGroupNameToolShort
                          ? null
                          : context.read<VaultCreatePresenter>().createVault,
                      child: const Text('Continue'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
}
