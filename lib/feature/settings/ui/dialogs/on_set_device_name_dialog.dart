import 'package:guardian_keyper/consts.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';

import '../settings_presenter.dart';

class OnSetDeviceNameDialog extends StatelessWidget {
  static Future<void> show(
    BuildContext context, {
    required SettingsPresenter presenter,
  }) =>
      Navigator.of(context).push(
        MaterialPageRoute(
          fullscreenDialog: true,
          builder: (_) => ChangeNotifierProvider.value(
            value: presenter,
            child: const OnSetDeviceNameDialog(),
          ),
        ),
      );

  const OnSetDeviceNameDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final presenter = context.read<SettingsPresenter>();
    return ScaffoldSafe(
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
                    style: stylePoppins620,
                  ),
                ),
                Padding(
                  padding: paddingV20,
                  child: TextFormField(
                    autofocus: true,
                    keyboardType: TextInputType.text,
                    maxLength: maxNameLength,
                    initialValue: presenter.deviceName,
                    onChanged: (value) => presenter.deviceName = value,
                    decoration: const InputDecoration(
                      labelText: ' Device name ',
                      helperText: 'Minimum $minNameLength characters',
                    ),
                  ),
                ),
                // Footer
                Padding(
                  padding: paddingV20,
                  child: Consumer<SettingsPresenter>(
                    builder: (context, presenter, __) => FilledButton(
                      onPressed: presenter.hasMinimumDeviceNameLength
                          ? () async {
                              await presenter.setDeviceName();
                              if (context.mounted) Navigator.of(context).pop();
                            }
                          : null,
                      child: const Text('Proceed'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
