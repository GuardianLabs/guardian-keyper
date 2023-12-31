import 'package:guardian_keyper/ui/widgets/common.dart';

import 'package:guardian_keyper/feature/settings/ui/widgets/device_name_input.dart';

class OnSetDeviceNameDialog extends StatelessWidget {
  static Future<void> show(BuildContext context) =>
      Navigator.of(context).push(MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => const OnSetDeviceNameDialog(),
      ));

  const OnSetDeviceNameDialog({super.key});

  @override
  Widget build(BuildContext context) => ScaffoldSafe(
        header: const HeaderBar(
          caption: 'Change Device Name',
          leftButton: HeaderBarButton.back(),
        ),
        child: DeviceNameInput(
          onProceed: () {
            if (context.mounted) Navigator.of(context).pop();
          },
        ),
      );
}
