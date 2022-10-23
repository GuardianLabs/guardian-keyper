import '/src/core/theme/theme.dart';
import '/src/core/widgets/common.dart';

import '../add_secret_controller.dart';

import '../widgets/add_secret_close_button.dart';

class AddNamePage extends StatelessWidget {
  const AddNamePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<AddSecretController>();
    return Column(
      children: [
        // Header
        const HeaderBar(
          caption: 'Add a name',
          closeButton: AddSecretCloseButton(),
        ),
        // Body
        Padding(
          padding: paddingTop32,
          child: Text(
            'Add a name for your Secret',
            style: textStylePoppins620,
          ),
        ),
        // Input
        Padding(
          padding: paddingTop32 + paddingH20,
          child: TextFormField(
            keyboardType: TextInputType.name,
            maxLines: 1,
            maxLength: controller.globals.maxNameLength,
            style: textStyleSourceSansPro416,
            decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.always,
              labelText: ' Secret name ',
              counterStyle: textStyleSourceSansPro414Purple,
            ),
            onChanged: (value) => controller.secretName = value,
          ),
        ),
        // Footer
        Padding(
          padding: paddingTop32 + paddingH20,
          child: Selector<AddSecretController, bool>(
            selector: (_, controller) => controller.isNameTooShort,
            builder: (_, isNameTooShort, __) => PrimaryButton(
              text: 'Continue',
              onPressed: isNameTooShort ? null : controller.nextScreen,
            ),
          ),
        ),
      ],
    );
  }
}
