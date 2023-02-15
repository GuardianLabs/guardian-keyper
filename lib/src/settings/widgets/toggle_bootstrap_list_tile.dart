import '/src/core/model/core_model.dart';
import '/src/core/di_container.dart';
import '/src/core/widgets/common.dart';
import '/src/core/widgets/icon_of.dart';

class ToggleBootstrapListTile extends StatelessWidget {
  const ToggleBootstrapListTile({super.key});

  @override
  Widget build(BuildContext context) {
    final diContainer = context.read<DIContainer>();
    return ValueListenableBuilder<Box<SettingsModel>>(
      valueListenable: diContainer.boxSettings.listenable(),
      builder: (_, boxSettings, __) => SwitchListTile.adaptive(
        secondary: const IconOf.splitAndShare(),
        title: const Text('Proxy connection'),
        subtitle: const Text(
          'Connect through Keyper-operated proxy server',
        ),
        value: boxSettings.isProxyEnabled,
        onChanged: (isOn) {
          diContainer.boxSettings.isProxyEnabled = isOn;
          if (isOn) {
            diContainer.networkService.addBootstrapServer(
              peerId: diContainer.globals.bsPeerId,
              ipV4: diContainer.globals.bsAddressV4,
              ipV6: diContainer.globals.bsAddressV6,
              port: diContainer.globals.bsPort,
            );
          } else {
            diContainer.networkService.addBootstrapServer(
              peerId: diContainer.globals.bsPeerId,
            );
          }
        },
      ),
    );
  }
}
