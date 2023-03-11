import '/src/core/widgets/common.dart';
import '/src/core/widgets/icon_of.dart';
import '/src/core/model/core_model.dart';
import '../../settings/settings_controller.dart';

import '../intro_controller.dart';

class SetDeviceNamePage extends StatelessWidget {
  const SetDeviceNamePage({super.key});

  @override
  Widget build(final BuildContext context) => ListView(
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
                initialValue: GetIt.I<SettingsController>().state.deviceId.name,
                onChanged: GetIt.I<SettingsController>().setDeviceName,
                keyboardType: TextInputType.text,
                maxLength: IdWithNameBase.maxNameLength,
                decoration: const InputDecoration(
                  labelText: ' Guardian name ',
                  helperText: 'Minimum 3 characters',
                ),
              )),
          Padding(
            padding: paddingV20,
            child: BlocBuilder<SettingsController, SettingsModel>(
              bloc: GetIt.I<SettingsController>(),
              builder: (final context, final state) => PrimaryButton(
                text: 'Proceed',
                onPressed: state.isNameTooShort
                    ? null
                    : () async {
                        await GetIt.I<SettingsController>().saveDeviceName();
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
