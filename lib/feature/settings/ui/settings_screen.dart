import 'package:guardian_keyper/ui/utils.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/ui/widgets/icon_of.dart';
import 'package:guardian_keyper/feature/auth/auth.dart';

import 'settings_presenter.dart';
import 'dialogs/on_set_device_name_page.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(final BuildContext context) => ChangeNotifierProvider(
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
                  builder: (
                    final BuildContext context,
                    final SettingsPresenter presenter,
                    final Widget? widget,
                  ) =>
                      ListView(
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
                          onTap: () async {
                            final newName = await OnSetDeviceNameDialog.show(
                              context,
                              deviceName: presenter.deviceName,
                            );
                            if (newName == null) return;
                            if (presenter.deviceName == newName) return;
                            await presenter.setDeviceName(newName);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(buildSnackBar(
                                text: 'Device name was changed successfully.',
                              ));
                            }
                          },
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
                              ? showCreatePassCode(
                                  context: context,
                                  onConfirmed: presenter.setPassCode,
                                  onVibrate: presenter.vibrate,
                                )
                              : showChangePassCode(
                                  context: context,
                                  onConfirmed: presenter.setPassCode,
                                  currentPassCode: presenter.passCode,
                                  onVibrate: presenter.vibrate,
                                ),
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
