import '/src/core/widgets/common.dart';
import '/src/core/model/core_model.dart';

// TBD: use itself Provider?
// TBD: use nested Navigator?
class SetDeviceNamePage extends StatefulWidget {
  final String deviceName;

  const SetDeviceNamePage({super.key, required this.deviceName});

  @override
  State<SetDeviceNamePage> createState() => _SetDeviceNamePageState();
}

class _SetDeviceNamePageState extends State<SetDeviceNamePage> {
  late String _deviceName = widget.deviceName;

  @override
  Widget build(final BuildContext context) => ScaffoldSafe(
        child: Column(
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
                      'Create new Device name',
                      textAlign: TextAlign.center,
                      style: textStylePoppins620,
                    ),
                  ),
                  Padding(
                    padding: paddingV20,
                    child: TextFormField(
                      autofocus: true,
                      keyboardType: TextInputType.text,
                      maxLength: IdWithNameBase.maxNameLength,
                      initialValue: _deviceName,
                      onChanged: (value) => setState(() => _deviceName = value),
                      decoration: const InputDecoration(
                        labelText: ' Device name ',
                        helperText:
                            'Minimum ${IdWithNameBase.minNameLength} characters',
                      ),
                    ),
                  ),
                  // Footer
                  Padding(
                    padding: paddingV20,
                    child: PrimaryButton(
                      text: 'Proceed',
                      onPressed:
                          _deviceName.length < IdWithNameBase.minNameLength
                              ? null
                              : () => Navigator.of(context).pop(_deviceName),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}
