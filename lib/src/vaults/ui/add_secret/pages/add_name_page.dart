import 'package:guardian_keyper/src/core/app/consts.dart';
import 'package:guardian_keyper/src/core/ui/widgets/common.dart';

import '../vault_add_secret_presenter.dart';
import '../widgets/add_secret_close_button.dart';

class AddNamePage extends StatelessWidget {
  const AddNamePage({super.key});

  @override
  Widget build(final BuildContext context) {
    final presenter = context.read<VaultAddSecretPresenter>();
    return ListView(
      shrinkWrap: true,
      children: [
        // Header
        const HeaderBar(
          caption: 'Add a name',
          closeButton: AddSecretCloseButton(),
        ),
        // Body
        const PageTitle(title: 'Add a name for your Secret'),
        // Input
        Padding(
          padding: paddingTop32 + paddingH20,
          child: TextFormField(
            keyboardType: TextInputType.name,
            maxLines: 1,
            maxLength: maxNameLength,
            style: textStyleSourceSansPro416,
            decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.always,
              labelText: ' Secret name ',
              counterStyle: textStyleSourceSansPro414Purple,
            ),
            onChanged: (value) => presenter.secretName = value,
          ),
        ),
        // Footer
        Padding(
          padding: paddingTop32 + paddingH20,
          child: Selector<VaultAddSecretPresenter, bool>(
            selector: (_, controller) => controller.isNameTooShort,
            builder: (_, isNameTooShort, __) => PrimaryButton(
              text: 'Continue',
              onPressed: isNameTooShort ? null : presenter.nextScreen,
            ),
          ),
        ),
      ],
    );
  }
}
