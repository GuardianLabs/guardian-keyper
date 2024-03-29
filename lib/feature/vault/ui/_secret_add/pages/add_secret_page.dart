import 'package:guardian_keyper/consts.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';

import '../vault_secret_add_presenter.dart';
import '../widgets/abort_header_button.dart';
import '../dialogs/on_secret_sharing_dialog.dart';

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
          leftButton: HeaderBarButton.back(onPressed: presenter.previousPage),
          rightButton: const AbortHeaderButton(),
        ),
        // Body
        Expanded(
          child: ListView(
            padding: paddingH20,
            children: [
              const PageTitle(
                title: 'Enter the Secret',
              ),
              // Input
              TextFormField(
                autofocus: true,
                maxLines: null,
                maxLength: maxSecretLength,
                initialValue: presenter.secret,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  labelText: ' Your Secret ',
                ),
                onTapOutside: (_) => FocusScope.of(context).unfocus(),
                onChanged: presenter.setSecret,
              ),
              // Footer
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Selector<VaultSecretAddPresenter, String>(
                  selector: (_, p) => p.secret,
                  builder: (_, secret, __) => FilledButton(
                    onPressed: secret.isEmpty
                        ? null
                        : () {
                            if (presenter.isUnderstandingShardsHidden) {
                              presenter.nextPage();
                            } else {
                              OnSecretSharingDialog.show(
                                context,
                                maxSize: presenter.vault.maxSize,
                              ).then((r) {
                                if (r ?? false) presenter.nextPage();
                              });
                            }
                          },
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
