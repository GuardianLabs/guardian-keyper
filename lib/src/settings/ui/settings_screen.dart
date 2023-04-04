import '/src/core/consts.dart';
import '/src/core/ui/widgets/common.dart';
import '/src/core/ui/widgets/icon_of.dart';
import '/src/core/ui/widgets/auth/auth.dart';

import 'settings_presenter.dart';
// import 'pages/emoji_list_page.dart';
import 'pages/set_device_name_page.dart';

class SettingsScreen extends StatelessWidget {
  static const routeName = routeSettings;

  static MaterialPageRoute<void> getPageRoute(final RouteSettings settings) =>
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        settings: settings,
        builder: (_) => const SettingsScreen(),
      );

  const SettingsScreen({super.key});

  @override
  Widget build(final BuildContext context) => ScaffoldSafe(
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
                builder: (context, provider, _) => ListView(
                  padding: paddingAll20,
                  children: [
                    // Change Device Name
                    Padding(
                      padding: paddingV6,
                      child: ListTile(
                        leading: const IconOf.shardOwner(),
                        title: const Text('Change Guardian name'),
                        subtitle: Text(
                          provider.deviceName,
                          style: textStyleSourceSansPro414Purple,
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios_rounded),
                        onTap: () async {
                          final newName = await Navigator.of(context).push(
                            MaterialPageRoute<String>(
                              fullscreenDialog: true,
                              builder: (_) => SetDeviceNamePage(
                                deviceName: provider.deviceName,
                              ),
                            ),
                          );
                          if (newName == null) return;
                          await provider.setDeviceName(newName);
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
                        onTap: () => provider.passCode.isEmpty
                            ? showCreatePassCode(
                                context: context,
                                onConfirmed: provider.setPassCode,
                                onVibrate: provider.vibrate,
                              )
                            : showChangePassCode(
                                context: context,
                                onConfirmed: provider.setPassCode,
                                currentPassCode: provider.passCode,
                                onVibrate: provider.vibrate,
                              ),
                      ),
                    ),
                    // Toggle Biometrics
                    if (provider.hasBiometrics)
                      Padding(
                        padding: paddingV6,
                        child: SwitchListTile.adaptive(
                          secondary: const IconOf.biometricLogon(),
                          title: const Text('Biometric login'),
                          subtitle: const Text(
                            'Easier, faster authentication with biometry',
                          ),
                          value: provider.isBiometricsEnabled,
                          onChanged: provider.setIsBiometricsEnabled,
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
                        value: provider.isBootstrapEnabled,
                        onChanged: provider.setIsBootstrapEnabled,
                      ),
                    ),
                    // Emoji list
                    // Padding(
                    //   padding: paddingV6,
                    //   child: OutlinedButton(
                    //     onPressed: () => Navigator.of(context)
                    //         .push(EmojiListPage.getPageRoute()),
                    //     child: const Text('Emoji of Secret'),
                    //   ),
                    // ),
                    // Emoji picker
                    // Padding(
                    //   padding: paddingV6,
                    //   child: OutlinedButton(
                    //     onPressed: () => Navigator.of(context).push(
                    //         EmojiPage.getPageRoute(
                    //             const RouteSettings(arguments: 'Vault'))),
                    //     child: const Text('Emoji of Vault'),
                    //   ),
                    // ),
                    // Padding(
                    //   padding: paddingV6,
                    //   child: OutlinedButton(
                    //     onPressed: () => Navigator.of(context).push(
                    //         EmojiPage.getPageRoute(
                    //             const RouteSettings(arguments: 'Peer'))),
                    //     child: const Text('Emoji of Peer'),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
}
