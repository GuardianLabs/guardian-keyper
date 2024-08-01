import 'package:guardian_keyper/consts.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';

import '../vault_create_presenter.dart';

class InputNamePage extends StatelessWidget {
  const InputNamePage({super.key});

  @override
  Widget build(BuildContext context) {
    final presenter = context.read<VaultCreatePresenter>();
    return ScaffoldSafe(
      appBar: AppBar(
        title: const Text('Name your Safe'),
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
              padding: paddingH20,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 32),
                  child: TextField(
                    autofocus: true,
                    keyboardType: TextInputType.text,
                    maxLength: maxNameLength,
                    decoration: const InputDecoration(
                      labelText: ' Safe name ',
                    ),
                    onTapOutside: (_) => FocusScope.of(context).unfocus(),
                    onChanged: presenter.setVaultName,
                  ),
                ),
                // Footer
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Selector<VaultCreatePresenter, bool>(
                    selector: (context, presenter) =>
                        presenter.isVaultNameTooShort,
                    builder: (context, isGroupNameToolShort, _) => FilledButton(
                      onPressed:
                          isGroupNameToolShort ? null : presenter.createVault,
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
