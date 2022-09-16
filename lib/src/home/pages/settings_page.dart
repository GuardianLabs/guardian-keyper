import '/src/core/di_container.dart';
import '/src/core/model/core_model.dart';
import '/src/core/theme_data.dart';
import '/src/core/widgets/common.dart';
import '/src/core/widgets/icon_of.dart';

import 'set_device_name_page.dart';
import '../widgets/change_passcode_widget.dart';
import '../widgets/hidden_settings_widget.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final diContainer = context.read<DIContainer>();
    return Column(
      children: [
        // Header
        const HeaderBar(
          caption: 'Settings',
          closeButton: HeaderBarCloseButton(),
        ),
        // Body
        Expanded(
          child: ListView(
            padding: paddingAll20,
            children: [
              // Change Device Name
              Padding(
                padding: paddingV6,
                child: ListTile(
                  leading: const IconOf.shardOwner(),
                  title: const Text('Change Guardian name'),
                  subtitle: ValueListenableBuilder<Box<SettingsModel>>(
                    valueListenable: diContainer.boxSettings.listenable(),
                    builder: (_, boxSettings, __) => Text(
                      boxSettings.deviceName,
                      style: textStyleSourceSansPro414Purple,
                    ),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded),
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) =>
                          const ScaffoldWidget(child: SetDeviceNamePage()))),
                ),
              ),
              // Change PassCode
              const Padding(padding: paddingV6, child: ChangePassCodeWidget()),
              // Use Biometrics
              if (diContainer.platformService.hasBiometrics)
                Padding(
                  padding: paddingV6,
                  child: ValueListenableBuilder<Box<SettingsModel>>(
                    valueListenable: diContainer.boxSettings.listenable(),
                    builder: (_, boxSettings, __) => SwitchListTile.adaptive(
                      secondary: const IconOf.biometricLogon(),
                      title: const Text('Biometric login'),
                      subtitle: const Text(
                          'Easier, faster authentication with biometry'),
                      value: boxSettings.isBiometricsEnabled,
                      onChanged: (value) =>
                          diContainer.boxSettings.isBiometricsEnabled = value,
                    ),
                  ),
                ),
              // Shows hidden settings
              const Padding(padding: paddingV6, child: HiddenSettingsWidget()),
            ],
          ),
        ),
      ],
    );
  }
}
