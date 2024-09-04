import 'package:guardian_keyper/consts.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';

import '../vault_secret_add_presenter.dart';

class AddNamePage extends StatelessWidget {
  const AddNamePage({super.key});

  @override
  Widget build(BuildContext context) {
    final presenter = context.read<VaultSecretAddPresenter>();
    return ScaffoldSafe(
      appBar: AppBar(
        title: const Text('Create a name for your Secret'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      child: Column(
        children: [
          // Body
          Expanded(
            child: ListView(children: [
              // Input
              Padding(
                padding: const EdgeInsets.only(
                    top: 32, left: kDefaultPadding, right: kDefaultPadding),
                child: TextFormField(
                  autofocus: true,
                  maxLength: kMaxNameLength,
                  keyboardType: TextInputType.name,
                  initialValue: presenter.secretName,
                  decoration: const InputDecoration(labelText: ' Secret name '),
                  onTapOutside: (_) => FocusScope.of(context).unfocus(),
                  onChanged: presenter.setSecretName,
                ),
              ),
              // Footer
              Padding(
                padding: const EdgeInsets.only(
                    top: 32, left: kDefaultPadding, right: kDefaultPadding),
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
      ),
    );
  }
}
