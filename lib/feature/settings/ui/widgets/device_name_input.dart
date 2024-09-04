import 'package:guardian_keyper/consts.dart';
import 'package:guardian_keyper/ui/presenters/settings_presenter.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';

class DeviceNameInput extends StatefulWidget {
  const DeviceNameInput({
    required this.onProceed,
    super.key,
  });

  final VoidCallback onProceed;

  @override
  State<DeviceNameInput> createState() => _DeviceNameInputState();
}

class _DeviceNameInputState extends State<DeviceNameInput> {
  late final _settingsPresenter = context.read<SettingsPresenter>();

  late final _inputController = TextEditingController(
    text: _settingsPresenter.name,
  );

  late bool _canProceed = _settingsPresenter.name.length >= kMinNameLength;

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: paddingAll20,
            child: TextField(
              autofocus: true,
              maxLength: kMaxNameLength,
              controller: _inputController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                labelText: ' Device name ',
                helperText: 'Minimum $kMinNameLength characters',
              ),
              onTapOutside: (_) => FocusScope.of(context).unfocus(),
              onChanged: (value) {
                if (value.length >= kMinNameLength && !_canProceed) {
                  setState(() => _canProceed = true);
                } else if (value.length < kMinNameLength && _canProceed) {
                  setState(() => _canProceed = false);
                }
              },
            ),
          ),
          Padding(
            padding: paddingAll20,
            child: FilledButton(
              onPressed: _canProceed
                  ? () async {
                      await _settingsPresenter
                          .setDeviceName(_inputController.value.text);
                      widget.onProceed();
                    }
                  : null,
              child: const Text('Proceed'),
            ),
          ),
        ],
      );
}
