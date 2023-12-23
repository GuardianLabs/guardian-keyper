import 'package:guardian_keyper/consts.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';

import 'package:guardian_keyper/feature/network/data/network_manager.dart';

class OnSetDeviceNameDialog extends StatefulWidget {
  static Future<void> show(BuildContext context) =>
      Navigator.of(context).push(MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => const OnSetDeviceNameDialog(),
      ));

  const OnSetDeviceNameDialog({super.key});

  @override
  State<OnSetDeviceNameDialog> createState() => _OnSetDeviceNameDialogState();
}

class _OnSetDeviceNameDialogState extends State<OnSetDeviceNameDialog> {
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
  Widget build(BuildContext context) => ScaffoldSafe(
        header: const HeaderBar(
          caption: 'Change Device Name',
          leftButton: HeaderBarButton.back(),
        ),
        children: [
          const PageTitle(title: 'Create new Device name'),
          Padding(
            padding: paddingV20,
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
            padding: paddingV20,
            child: FilledButton(
              onPressed: _canProceed
                  ? () async {
                      await _networkManager
                          .setDeviceName(_inputController.value.text);
                      if (context.mounted) Navigator.of(context).pop();
                    }
                  : null,
              child: const Text('Proceed'),
            ),
          ),
        ],
      );
}
