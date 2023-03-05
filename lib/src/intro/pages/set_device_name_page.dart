import '/src/core/theme/theme.dart';
import '/src/core/widgets/common.dart';
import '/src/core/widgets/icon_of.dart';

import '../intro_controller.dart';

class SetDeviceNamePage extends StatelessWidget {
  const SetDeviceNamePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<IntroController>();
    return ListView(
      padding: paddingAll20,
      children: [
        const Padding(padding: paddingV20, child: IconOf.app(isBig: true)),
        Padding(
          padding: paddingV20,
          child: Text(
            'Create your Guardian name',
            textAlign: TextAlign.center,
            style: textStylePoppins620,
          ),
        ),
        Padding(
            padding: paddingV20,
            child: TextFormField(
              autofocus: true,
              initialValue: controller.deviceName,
              onChanged: (value) => controller.deviceName = value,
              keyboardType: TextInputType.text,
              maxLength: controller.globals.maxNameLength,
              decoration: const InputDecoration(
                labelText: ' Guardian name ',
                helperText: 'Minimum 3 characters',
              ),
            )),
        Padding(
          padding: paddingV20,
          child: Selector<IntroController, String>(
            selector: (_, c) => c.deviceName,
            builder: (_, __, ___) => PrimaryButton(
              text: 'Proceed',
              onPressed: controller.onSaveDeviceName(),
            ),
          ),
        ),
      ],
    );
  }
}
