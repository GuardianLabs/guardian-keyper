import '/src/core/widgets/common.dart';

import '../settings_repository.dart';

// TBD: create SettingsController
class SetDeviceNamePage extends StatefulWidget {
  const SetDeviceNamePage({super.key});

  @override
  State<SetDeviceNamePage> createState() => _SetDeviceNamePageState();
}

class _SetDeviceNamePageState extends State<SetDeviceNamePage> {
  final _settingsRepository = GetIt.I<SettingsRepository>();

  late String _deviceName = _settingsRepository.state.deviceName;

  @override
  Widget build(final BuildContext context) => Column(
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
                    maxLength: SettingsModel.maxNameLength,
                    initialValue: _deviceName,
                    onChanged: (value) => setState(() => _deviceName = value),
                    decoration: const InputDecoration(
                      labelText: ' Device name ',
                      helperText: 'Minimum 3 characters',
                    ),
                  ),
                ),
                // Footer
                Padding(
                  padding: paddingV20,
                  child: BlocBuilder<SettingsRepository, SettingsModel>(
                    bloc: _settingsRepository,
                    builder: (final context, final state) => PrimaryButton(
                      text: 'Proceed',
                      onPressed: state.deviceName.length <
                              SettingsModel.maxNameLength
                          ? null
                          : () async {
                              await _settingsRepository
                                  .setDeviceName(_deviceName);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(buildSnackBar(
                                  text: 'Device name was changed successfully.',
                                ));
                                Navigator.of(context).pop();
                              }
                            },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
}
