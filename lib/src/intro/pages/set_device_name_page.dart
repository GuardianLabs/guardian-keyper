import '/src/core/ui/widgets/common.dart';
import '/src/core/ui/widgets/icon_of.dart';

import '../intro_controller.dart';

class SetDeviceNamePage extends StatelessWidget {
  const SetDeviceNamePage({super.key});

  @override
  Widget build(final BuildContext context) {
    final controller = context.read<IntroController>();
    return ListView(
      padding: paddingAll20,
      children: [
        const Padding(
          padding: paddingV20,
          child: IconOf.app(isBig: true),
        ),
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
              onChanged: controller.setDeviceName,
              keyboardType: TextInputType.text,
              maxLength: controller.maxNameLength,
              decoration: InputDecoration(
                labelText: ' Guardian name ',
                helperText: 'Minimum ${controller.minNameLength} characters',
              ),
            )),
        Padding(
          padding: paddingV20,
          child: Consumer<IntroController>(
            builder: (_, controller, ___) => PrimaryButton(
              text: 'Proceed',
              onPressed:
                  controller.canSaveName ? controller.saveDeviceName : null,
            ),
          ),
        ),
      ],
    );
  }
}
