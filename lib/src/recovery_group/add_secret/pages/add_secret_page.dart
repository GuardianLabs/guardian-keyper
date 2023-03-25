import '/src/core/consts.dart';
import '/src/core/ui/widgets/common.dart';

import '../add_secret_controller.dart';
import '../widgets/add_secret_close_button.dart';

class AddSecretPage extends StatefulWidget {
  const AddSecretPage({super.key});

  @override
  State<AddSecretPage> createState() => _AddSecretPageState();
}

class _AddSecretPageState extends State<AddSecretPage> {
  var _isSecretObscure = true;

  @override
  Widget build(final BuildContext context) {
    final controller = context.read<AddSecretController>();
    return Column(
      children: [
        // Header
        HeaderBar(
          caption: 'Add your Secret',
          backButton: HeaderBarBackButton(onPressed: controller.previousScreen),
          closeButton: const AddSecretCloseButton(),
        ),
        // Body
        Expanded(
          child: ListView(
            primary: true,
            shrinkWrap: true,
            padding: paddingH20,
            children: [
              PageTitle(
                titleSpans: [
                  TextSpan(
                    text: 'Add your Secret for ${controller.group.id.name} ',
                  ),
                  TextSpan(text: controller.group.id.emoji),
                ],
                subtitle: 'Make sure no one can see your screen.',
              ),
              // Input
              TextFormField(
                enableInteractiveSelection: true,
                contextMenuBuilder: (context, editableTextState) =>
                    AdaptiveTextSelectionToolbar.buttonItems(
                  anchors: editableTextState.contextMenuAnchors,
                  buttonItems: editableTextState.contextMenuButtonItems,
                ),
                keyboardType: TextInputType.multiline,
                obscureText: _isSecretObscure,
                maxLines: _isSecretObscure ? 1 : null,
                maxLength: maxSecretLength,
                style: textStyleSourceSansPro416,
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelText: ' Your Secret ',
                  counterStyle: textStyleSourceSansPro414Purple,
                  suffix: _isSecretObscure
                      ? Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: clBlue),
                            shape: BoxShape.circle,
                          ),
                          height: 40,
                          child: IconButton(
                            color: clWhite,
                            icon: const Icon(Icons.visibility_outlined),
                            onPressed: () => setState(
                              () => _isSecretObscure = !_isSecretObscure,
                            ),
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
                            onPressed: () => setState(
                              () => _isSecretObscure = !_isSecretObscure,
                            ),
                          ),
                        ),
                ),
                onChanged: (value) => controller.secret = value,
              ),
              // Footer
              Padding(
                padding: paddingV32,
                child: Selector<AddSecretController, String>(
                  selector: (_, controller) => controller.secret,
                  builder: (_, secret, __) => PrimaryButton(
                    text: 'Continue',
                    onPressed: secret.isEmpty ? null : controller.nextScreen,
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
