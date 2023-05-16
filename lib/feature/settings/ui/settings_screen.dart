import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/ui/widgets/icon_of.dart';

import 'package:guardian_keyper/feature/auth/ui/dialogs/on_create_pass_code.dart';
import 'package:guardian_keyper/feature/auth/ui/dialogs/on_change_pass_code_dialog.dart';

import 'settings_presenter.dart';
import 'dialogs/on_set_device_name_page.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (_) => SettingsPresenter(),
        child: ScaffoldSafe(
          child: Column(
            children: [
              // Header
              const HeaderBar(
                caption: 'Settings',
                closeButton: HeaderBarCloseButton(),
              ),
              // Body
              Expanded(
                child: Consumer<SettingsPresenter>(
                  builder: (context, presenter, __) => ListView(
                    padding: paddingAll20,
                    children: [
                      // Change Device Name
                      Padding(
                        padding: paddingV6,
                        child: ListTile(
                          leading: const IconOf.shardOwner(),
                          title: const Text('Change Guardian name'),
                          subtitle: Text(
                            presenter.deviceName,
                            style: textStyleSourceSansPro414Purple,
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios_rounded),
                          onTap: () => OnSetDeviceNameDialog.show(
                            context,
                            presenter: presenter,
                          ),
                        ),
                      ),
                      // Change PassCode
                      Padding(
                        padding: paddingV6,
                        child: ListTile(
                          leading: const IconOf.passcode(),
                          title: const Text('Passcode'),
                          subtitle: Text(
                            'Change authentication passcode',
                            style: textStyleSourceSansPro414Purple,
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios_rounded),
                          onTap: () => presenter.passCode.isEmpty
                              ? OnCreatePassCodeDialog.show(context)
                              : OnChangePassCodeDialog.show(context),
                        ),
                      ),
                      // Toggle Biometrics
                      if (presenter.hasBiometrics)
                        Padding(
                          padding: paddingV6,
                          child: SwitchListTile.adaptive(
                            secondary: const IconOf.biometricLogon(),
                            title: const Text('Biometric login'),
                            subtitle: const Text(
                              'Easier, faster authentication with biometry',
                            ),
                            value: presenter.isBiometricsEnabled,
                            onChanged: presenter.setIsBiometricsEnabled,
                          ),
                        ),
                      // Toggle Bootstrap
                      Padding(
                        padding: paddingV6,
                        child: SwitchListTile.adaptive(
                          secondary: const IconOf.splitAndShare(),
                          title: const Text('Proxy connection'),
                          subtitle: const Text(
                            'Connect through Keyper-operated proxy server',
                          ),
                          value: presenter.isBootstrapEnabled,
                          onChanged: presenter.setIsBootstrapEnabled,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
