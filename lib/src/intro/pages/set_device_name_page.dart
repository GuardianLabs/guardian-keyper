import '/src/core/di_container.dart';
import '/src/core/theme_data.dart';
import '/src/core/widgets/common.dart';
import '/src/core/widgets/icon_of.dart';

import '../intro_controller.dart';

class SetDeviceNamePage extends StatefulWidget {
  const SetDeviceNamePage({super.key});

  @override
  State<SetDeviceNamePage> createState() => _SetDeviceNamePageState();
}

class _SetDeviceNamePageState extends State<SetDeviceNamePage> {
  late final DIContainer diContainer;
  String _deviceName = '';

  @override
  void initState() {
    super.initState();
    diContainer = context.read<DIContainer>();
    _deviceName = diContainer.boxSettings.deviceName;
  }

  @override
  Widget build(BuildContext context) => ListView(
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
                initialValue: _deviceName,
                onChanged: (value) => setState(() => _deviceName = value),
                keyboardType: TextInputType.text,
                maxLength: diContainer.globals.maxNameLength,
                decoration: const InputDecoration(
                  labelText: ' Guardian name ',
                  helperText: 'Minimum 3 characters',
                ),
              )),
          Padding(
            padding: paddingV20,
            child: PrimaryButton(
              text: 'Proceed',
              onPressed: _deviceName.length < diContainer.globals.minNameLength
                  ? null
                  : () {
                      diContainer.boxSettings.deviceName = _deviceName;
                      context.read<IntroController>().nextScreen();
                    },
            ),
          ),
        ],
      );
}
