import 'package:guardian_keyper/src/core/consts.dart';
import 'package:guardian_keyper/src/core/ui/widgets/common.dart';

import '../presenters/vault_secret_add_presenter.dart';
import '../widgets/abort_header_button.dart';

class AddNamePage extends StatelessWidget {
  const AddNamePage({super.key});

  @override
  Widget build(final BuildContext context) => ListView(
        shrinkWrap: true,
        children: [
          // Header
          const HeaderBar(
            caption: 'Add a name',
            closeButton: AbortHeaderButton(),
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
              onChanged: context.read<VaultSecretAddPresenter>().setSecretName,
            ),
          ),
          // Footer
          Padding(
            padding: paddingTop32 + paddingH20,
            child: Selector<VaultSecretAddPresenter, bool>(
              selector: (_, presenter) => presenter.isNameTooShort,
              builder: (
                final BuildContext context,
                final bool isNameTooShort,
                final Widget? widget,
              ) =>
                  PrimaryButton(
                text: 'Continue',
                onPressed: isNameTooShort
                    ? null
                    : context.read<VaultSecretAddPresenter>().nextPage,
              ),
            ),
          ),
        ],
      );
}
