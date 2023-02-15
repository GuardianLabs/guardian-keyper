import '/src/core/theme/theme.dart';
import '/src/core/widgets/common.dart';

import 'widgets/change_device_name_list_tile.dart';
import 'widgets/change_passcode_list_tile.dart';
import 'widgets/toggle_biometrics_list_tile.dart';
import 'widgets/toggle_bootstrap_list_tile.dart';

class SettingsView extends StatelessWidget {
  static const routeName = '/settings';

  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) => ScaffoldWidget(
        child: Column(
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
                children: const [
                  // Change Device Name
                  Padding(
                    padding: paddingV6,
                    child: ChangeDeviceNameListTile(),
                  ),
                  // Change PassCode
                  Padding(
                    padding: paddingV6,
                    child: ChangePassCodeListTile(),
                  ),
                  // Toggle Biometrics
                  ToggleBiometricsListTile(),
                  // Toggle Bootstrap
                  Padding(
                    padding: paddingV6,
                    child: ToggleBootstrapListTile(),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}
