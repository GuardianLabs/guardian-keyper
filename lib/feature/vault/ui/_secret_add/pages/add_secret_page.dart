import 'package:guardian_keyper/consts.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';

import '../vault_secret_add_presenter.dart';
import '../widgets/abort_header_button.dart';

class AddSecretPage extends StatelessWidget {
  const AddSecretPage({super.key});

  @override
  Widget build(BuildContext context) {
    final presenter = context.read<VaultSecretAddPresenter>();
    return Column(
      children: [
        // Header
        HeaderBar(
          caption: 'Adding a Secret',
          backButton: HeaderBarBackButton(onPressed: presenter.previousPage),
          closeButton: const AbortHeaderButton(),
        ),
        // Body
        Expanded(
          child: ListView(
            padding: paddingH20,
            children: [
              const PageTitle(title: 'Enter the Secret'),
              // Input
              TextFormField(
                decoration: const InputDecoration(labelText: ' Your Secret '),
                initialValue: presenter.secret,
                keyboardType: TextInputType.multiline,
                maxLength: maxSecretLength,
                maxLines: null,
                onChanged: presenter.setSecret,
              ),
              // Footer
              Padding(
                padding: paddingV32,
                child: Selector<VaultSecretAddPresenter, String>(
                  selector: (_, p) => p.secret,
                  builder: (_, secret, __) => FilledButton(
                    onPressed: secret.isEmpty ? null : presenter.nextPage,
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
}
