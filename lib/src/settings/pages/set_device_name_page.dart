import '/src/core/widgets/common.dart';
import '/src/core/repository/repository_root.dart';

import '../settings_repository.dart';

class SetDeviceNamePage extends StatefulWidget {
  const SetDeviceNamePage({super.key});

  @override
  State<SetDeviceNamePage> createState() => _SetDeviceNamePageState();
}

class _SetDeviceNamePageState extends State<SetDeviceNamePage> {
  late String _deviceName =
      GetIt.I<RepositoryRoot>().settingsRepository.state.deviceName;

  @override
  Widget build(final BuildContext context) => ScaffoldWidget(
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
                      maxLength: SettingsModel.maxNameLength,
                      initialValue: _deviceName,
                      onChanged: (value) => setState(() => _deviceName = value),
                      decoration: const InputDecoration(
                        labelText: ' Device name ',
                        helperText:
                            'Minimum ${SettingsModel.minNameLength} characters',
                      ),
                    ),
                  ),
                  // Footer
                  Padding(
                    padding: paddingV20,
                    child: PrimaryButton(
                      text: 'Proceed',
                      onPressed: _deviceName.length <
                              SettingsModel.minNameLength
                          ? null
                          : () async {
                              await GetIt.I<RepositoryRoot>()
                                  .settingsRepository
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
                ],
              ),
            ),
          ],
        ),
      );
}
