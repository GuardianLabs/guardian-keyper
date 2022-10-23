import '/src/core/di_container.dart';
import '/src/core/theme/theme.dart';
import '/src/core/widgets/common.dart';

class SetDeviceNamePage extends StatefulWidget {
  const SetDeviceNamePage({super.key});

  @override
  State<SetDeviceNamePage> createState() => _SetDeviceNamePageState();
}

class _SetDeviceNamePageState extends State<SetDeviceNamePage> {
  late final DIContainer diContainer;
  String _name = '';

  @override
  void initState() {
    super.initState();
    diContainer = context.read<DIContainer>();
    _name = diContainer.boxSettings.deviceName;
  }

  @override
  Widget build(BuildContext context) => Column(
        children: [
          // Header
          const HeaderBar(
            caption: 'Change Device Name',
            backButton: HeaderBarBackButton(),
          ),
          // Body
          Expanded(
            child: ListView(
              padding: paddingAll20,
              children: [
                Padding(
                  padding: paddingAll20,
                  child: Text(
                    'Create new Guardian name',
                    textAlign: TextAlign.center,
                    style: textStylePoppins620,
                  ),
                ),
                Padding(
                  padding: paddingV20,
                  child: TextFormField(
                    autofocus: true,
                    initialValue: _name,
                    keyboardType: TextInputType.text,
                    maxLength: diContainer.globals.maxNameLength,
                    onChanged: (value) => setState(() => _name = value),
                    decoration: const InputDecoration(
                      labelText: ' Guardian name ',
                      helperText: 'Minimum 3 characters',
                    ),
                  ),
                ),
                // Footer
                Padding(
                  padding: paddingV20,
                  child: PrimaryButton(
                    text: 'Proceed',
                    onPressed: _name.length < diContainer.globals.minNameLength
                        ? null
                        : () {
                            diContainer.boxSettings.deviceName = _name;
                            ScaffoldMessenger.of(context).showSnackBar(
                              buildSnackBar(
                                text: 'Device name was changed successfully.',
                              ),
                            );
                            Navigator.of(context).pop();
                          },
                  ),
                ),
              ],
            ),
          ),
        ],
      );
}
