import 'package:guardian_keyper/app/consts.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';

class OnSetDeviceNameDialog extends StatefulWidget {
  static Future<String?> show(
    final BuildContext context, {
    required final String deviceName,
  }) =>
      Navigator.of(context).push<String>(
        MaterialPageRoute<String>(
          fullscreenDialog: true,
          settings: RouteSettings(arguments: deviceName),
          builder: (_) => const OnSetDeviceNameDialog(),
        ),
      );

  const OnSetDeviceNameDialog({super.key});

  @override
  State<OnSetDeviceNameDialog> createState() => _OnSetDeviceNameDialogState();
}

class _OnSetDeviceNameDialogState extends State<OnSetDeviceNameDialog> {
  late String _deviceName =
      ModalRoute.of(context)?.settings.arguments as String;

  @override
  Widget build(final BuildContext context) => ScaffoldSafe(
        child: Column(
          children: [
            // Header
            const HeaderBar(
              caption: 'Change Device Name',
              backButton: HeaderBarBackButton(),
            ),
            // Body
            Expanded(
              child: ListView(
                padding: paddingAll20,
                children: [
                  Padding(
                    padding: paddingAll20,
                    child: Text(
                      'Create new Device name',
                      textAlign: TextAlign.center,
                      style: textStylePoppins620,
                    ),
                  ),
                  Padding(
                    padding: paddingV20,
                    child: TextFormField(
                      autofocus: true,
                      keyboardType: TextInputType.text,
                      maxLength: maxNameLength,
                      initialValue: _deviceName,
                      onChanged: (value) => setState(() => _deviceName = value),
                      decoration: const InputDecoration(
                        labelText: ' Device name ',
                        helperText: 'Minimum $minNameLength characters',
                      ),
                    ),
                  ),
                  // Footer
                  Padding(
                    padding: paddingV20,
                    child: PrimaryButton(
                      text: 'Proceed',
                      onPressed: _deviceName.length < minNameLength
                          ? null
                          : () => Navigator.of(context).pop(_deviceName),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}
