import 'package:guardian_keyper/consts.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';

import '../vault_secret_add_presenter.dart';
import '../widgets/abort_header_button.dart';

class AddNamePage extends StatelessWidget {
  const AddNamePage({super.key});

  @override
  Widget build(BuildContext context) {
    final presenter = context.read<VaultSecretAddPresenter>();
    return Column(
      children: [
        // Header
        const HeaderBar(
          caption: 'Adding a Secret',
          rightButton: AbortHeaderButton(),
        ),
        // Body
        Expanded(
          child: ListView(children: [
            const PageTitle(title: 'Create a name for your Secret'),
            // Input
            Padding(
              padding: const EdgeInsets.only(top: 32, left: 20, right: 20),
              child: TextFormField(
                autofocus: true,
                maxLength: maxNameLength,
                keyboardType: TextInputType.name,
                initialValue: presenter.secretName,
                decoration: const InputDecoration(labelText: ' Secret name '),
                onTapOutside: (_) => FocusScope.of(context).unfocus(),
                onChanged: presenter.setSecretName,
              ),
            ),
            // Footer
            Padding(
              padding: const EdgeInsets.only(top: 32, left: 20, right: 20),
              child: Selector<VaultSecretAddPresenter, bool>(
                selector: (_, p) => p.isNameTooShort,
                builder: (context, isNameTooShort, _) => FilledButton(
                  onPressed: isNameTooShort ? null : presenter.nextPage,
                  child: const Text('Continue'),
                ),
              ),
            ),
          ]),
        ),
      ],
    );
  }
}
