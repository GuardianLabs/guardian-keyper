import 'package:guardian_keyper/consts.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';

import '../vault_secret_add_presenter.dart';
import '../dialogs/on_secret_sharing_dialog.dart';

class AddSecretPage extends StatelessWidget {
  const AddSecretPage({super.key});

  @override
  Widget build(BuildContext context) {
    final presenter = context.read<VaultSecretAddPresenter>();
    return ScaffoldSafe(
      appBar: AppBar(
        title: const Text('Enter the Secret'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: presenter.previousPage,
        ),
      ),
      child: Column(
        children: [
          // Body
          Expanded(
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: 32, left: kDefaultPadding, right: kDefaultPadding),
                  child: TextFormField(
                    autofocus: true,
                    maxLines: null,
                    maxLength: kMaxSecretLength,
                    initialValue: presenter.secret,
                    keyboardType: TextInputType.multiline,
                    decoration:
                        const InputDecoration(labelText: ' Your Secret '),
                    onTapOutside: (_) => FocusScope.of(context).unfocus(),
                    onChanged: presenter.setSecret,
                  ),
                ),
                // Footer
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 32, horizontal: kDefaultPadding),
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
      ),
    );
  }
}
