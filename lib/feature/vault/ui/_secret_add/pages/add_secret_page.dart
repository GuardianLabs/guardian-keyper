import 'package:guardian_keyper/consts.dart';
import 'package:guardian_keyper/ui/widgets/emoji.dart';
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
          caption: 'Add your Secret',
          backButton: HeaderBarBackButton(onPressed: presenter.previousPage),
          closeButton: const AbortHeaderButton(),
        ),
        // Body
        Expanded(
          child: ListView(
            shrinkWrap: true,
            padding: paddingH20,
            children: [
              PageTitle(
                titleSpans: buildTextWithId(
                  leadingText: 'Add your Secret for ',
                  id: presenter.vault.id,
                ),
                subtitle: 'Make sure no one can see your screen.',
              ),
              // Input
              Selector<VaultSecretAddPresenter, bool>(
                selector: (_, p) => p.isSecretObscure,
                builder: (_, isSecretObscure, __) => TextFormField(
                  enableInteractiveSelection: true,
                  contextMenuBuilder: (_, final editableTextState) =>
                      AdaptiveTextSelectionToolbar.buttonItems(
                    anchors: editableTextState.contextMenuAnchors,
                    buttonItems: editableTextState.contextMenuButtonItems,
                  ),
                  keyboardType: TextInputType.multiline,
                  obscureText: isSecretObscure,
                  maxLines: isSecretObscure ? 1 : null,
                  maxLength: maxSecretLength,
                  style: textStyleSourceSansPro416,
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: ' Your Secret ',
                    counterStyle: textStyleSourceSansPro414Purple,
                    suffix: isSecretObscure
                        ? Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: clBlue),
                              shape: BoxShape.circle,
                            ),
                            height: 40,
                            child: IconButton(
                              color: clWhite,
                              icon: const Icon(Icons.visibility_outlined),
                              onPressed: presenter.toggleIsSecretObscure,
                            ),
                          )
                        : Container(
                            decoration: const BoxDecoration(
                              color: clBlue,
                              shape: BoxShape.circle,
                            ),
                            height: 40,
                            child: IconButton(
                              color: clWhite,
                              icon: const Icon(Icons.visibility_off_outlined),
                              onPressed: presenter.toggleIsSecretObscure,
                            ),
                          ),
                  ),
                  onChanged: presenter.setSecret,
                ),
              ),
              // Footer
              Padding(
                padding: paddingV32,
                child: Selector<VaultSecretAddPresenter, String>(
                  selector: (_, p) => p.secret,
                  builder: (_, secret, __) => PrimaryButton(
                    text: 'Continue',
                    onPressed: secret.isEmpty ? null : presenter.nextPage,
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
