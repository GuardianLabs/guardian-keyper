import 'package:guardian_keyper/consts.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';

import '../settings_presenter.dart';

class OnSetDeviceNameDialog extends StatelessWidget {
  static Future<void> show(BuildContext context) {
    final presenter = context.read<SettingsPresenter>();
    return Navigator.of(context).push(MaterialPageRoute(
      fullscreenDialog: true,
      builder: (_) => ChangeNotifierProvider.value(
        value: presenter,
        child: OnSetDeviceNameDialog(presenter: presenter),
      ),
    ));
  }

  const OnSetDeviceNameDialog({
    required this.presenter,
    super.key,
  });

  final SettingsPresenter presenter;

  @override
  Widget build(BuildContext context) => ScaffoldSafe(
        header: const HeaderBar(
          caption: 'Change Device Name',
          leftButton: HeaderBarButton.back(),
        ),
        children: [
          const PageTitle(title: 'Create new Device name'),
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
      );
}
