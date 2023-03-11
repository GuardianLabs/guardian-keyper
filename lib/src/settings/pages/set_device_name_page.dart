import '/src/core/widgets/common.dart';
import '/src/core/model/core_model.dart';

import '../settings_controller.dart';

class SetDeviceNamePage extends StatelessWidget {
  const SetDeviceNamePage({super.key});

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
                    initialValue:
                        GetIt.I<SettingsController>().state.deviceId.name,
                    keyboardType: TextInputType.text,
                    maxLength: IdWithNameBase.maxNameLength,
                    onChanged: GetIt.I<SettingsController>().setDeviceName,
                    decoration: const InputDecoration(
                      labelText: ' Device name ',
                      helperText: 'Minimum 3 characters',
                    ),
                  ),
                ),
                // Footer
                Padding(
                  padding: paddingV20,
                  child: BlocBuilder<SettingsController, SettingsModel>(
                    bloc: GetIt.I<SettingsController>(),
                    builder: (final context, final state) => PrimaryButton(
                      text: 'Proceed',
                      onPressed: state.isNameTooShort
                          ? null
                          : () async {
                              await GetIt.I<SettingsController>()
                                  .saveDeviceName();
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
