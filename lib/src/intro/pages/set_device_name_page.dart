import 'package:guardian_keyper/src/settings/settings_cubit.dart';

import '/src/core/theme/theme.dart';
import '/src/core/widgets/common.dart';
import '/src/core/widgets/icon_of.dart';

import '../intro_controller.dart';

class SetDeviceNamePage extends StatelessWidget {
  const SetDeviceNamePage({super.key});

  @override
  Widget build(BuildContext context) {
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
              initialValue: GetIt.I<SettingsCubit>().state.deviceName,
              onChanged: (value) => GetIt.I<SettingsCubit>().deviceName = value,
              keyboardType: TextInputType.text,
              maxLength: SettingsModel.maxNameLength,
              decoration: const InputDecoration(
                labelText: ' Guardian name ',
                helperText: 'Minimum 3 characters',
              ),
            )),
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
                        context.read<IntroController>().nextScreen();
                      }
                    },
            ),
          ),
        ),
      ],
    );
  }
}
