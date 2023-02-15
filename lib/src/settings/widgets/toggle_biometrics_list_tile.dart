import '/src/core/model/core_model.dart';
import '/src/core/di_container.dart';
import '/src/core/theme/theme.dart';
import '/src/core/widgets/common.dart';
import '/src/core/widgets/icon_of.dart';

class ToggleBiometricsListTile extends StatelessWidget {
  const ToggleBiometricsListTile({super.key});

  @override
  Widget build(BuildContext context) {
    final diContainer = context.read<DIContainer>();
    return FutureBuilder<bool>(
      initialData: false,
      future: diContainer.authService.hasBiometrics,
      builder: (_, snapshot) => Visibility(
        visible: snapshot.data ?? false,
        child: Padding(
          padding: paddingV6,
          child: ValueListenableBuilder<Box<SettingsModel>>(
            valueListenable: diContainer.boxSettings.listenable(),
            builder: (_, boxSettings, __) => SwitchListTile.adaptive(
              secondary: const IconOf.biometricLogon(),
              title: const Text('Biometric login'),
              subtitle: const Text(
                'Easier, faster authentication with biometry',
              ),
              value: boxSettings.isBiometricsEnabled,
              onChanged: (isOn) {
                diContainer.boxSettings.isBiometricsEnabled = isOn;
              },
            ),
          ),
        ),
      ),
    );
  }
}
