import '/src/core/theme/theme.dart';
import '/src/core/widgets/common.dart';

import '../settings_cubit.dart';

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
                    initialValue: GetIt.I<SettingsCubit>().state.deviceName,
                    keyboardType: TextInputType.text,
                    maxLength: SettingsModel.maxNameLength,
                    onChanged: (value) =>
                        GetIt.I<SettingsCubit>().deviceName = value,
                    // onChanged: GetIt.I<SettingsCubit>().setDeviceName,
                    decoration: const InputDecoration(
                      labelText: ' Device name ',
                      helperText: 'Minimum 3 characters',
                    ),
                  ),
                ),
                // Footer
                Padding(
                  padding: paddingV20,
                  child: BlocBuilder<SettingsCubit, SettingsModel>(
                    bloc: GetIt.I<SettingsCubit>(),
                    builder: (final context, final state) => PrimaryButton(
                      text: 'Proceed',
                      onPressed: state.isNameTooShort
                          ? null
                          : () async {
                              await GetIt.I<SettingsCubit>()
                                  .setDeviceName(state.deviceName);
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
