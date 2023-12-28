import 'package:guardian_keyper/consts.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';

import 'package:guardian_keyper/feature/network/data/network_manager.dart';

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
  final _networkManager = GetIt.I<NetworkManager>();

  late final _inputController = TextEditingController(
    text: _networkManager.selfId.name,
  );

  late bool _canProceed = _networkManager.selfId.name.length >= minNameLength;

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
              maxLength: maxNameLength,
              controller: _inputController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                labelText: ' Device name ',
                helperText: 'Minimum $minNameLength characters',
              ),
              onChanged: (value) {
                if (value.length >= minNameLength && !_canProceed) {
                  setState(() => _canProceed = true);
                } else if (value.length < minNameLength && _canProceed) {
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
                      await _networkManager
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
