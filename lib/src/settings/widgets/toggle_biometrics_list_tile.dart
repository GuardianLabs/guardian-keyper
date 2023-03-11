import '/src/core/widgets/common.dart';
import '/src/core/widgets/icon_of.dart';

import '../settings_controller.dart';

class ToggleBiometricsListTile extends StatelessWidget {
  const ToggleBiometricsListTile({super.key});

  @override
  Widget build(final BuildContext context) =>
      BlocBuilder<SettingsController, SettingsModel>(
        bloc: GetIt.I<SettingsController>(),
        builder: (_, final state) => SwitchListTile.adaptive(
          secondary: const IconOf.biometricLogon(),
          title: const Text('Biometric login'),
          subtitle: const Text('Easier, faster authentication with biometry'),
          value: state.isBiometricsEnabled,
          onChanged: GetIt.I<SettingsController>().setIsBiometricsEnabled,
        ),
      );
}
