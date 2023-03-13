import '/src/core/consts.dart';
import '/src/core/widgets/common.dart';

import 'settings_controller.dart';
import 'widgets/change_device_name_list_tile.dart';
import 'widgets/change_passcode_list_tile.dart';
import 'widgets/toggle_biometrics_list_tile.dart';
import 'widgets/toggle_bootstrap_list_tile.dart';

class SettingsScreen extends StatelessWidget {
  static const routeName = routeSettings;

  const SettingsScreen({super.key});

  @override
  Widget build(final BuildContext context) => ScaffoldWidget(
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
                children: [
                  // Change Device Name
                  const Padding(
                    padding: paddingV6,
                    child: ChangeDeviceNameListTile(),
                  ),
                  // Change PassCode
                  const Padding(
                    padding: paddingV6,
                    child: ChangePassCodeListTile(),
                  ),
                  // Toggle Biometrics
                  if (GetIt.I<SettingsController>().hasBiometrics)
                    const Padding(
                      padding: paddingV6,
                      child: ToggleBiometricsListTile(),
                    ),
                  // Toggle Bootstrap
                  const Padding(
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
