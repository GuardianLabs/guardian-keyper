import 'package:guardian_keyper/consts.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/ui/widgets/stepper_page.dart';

import 'package:guardian_keyper/feature/network/data/network_manager.dart';
import 'package:guardian_keyper/feature/onboarding/widgets/discard_button.dart';

class SetDeviceNamePage extends StatefulWidget {
  const SetDeviceNamePage({super.key});

  @override
  State<SetDeviceNamePage> createState() => _SetDeviceNamePageState();
}

class _SetDeviceNamePageState extends State<SetDeviceNamePage> {
  final _networkManager = GetIt.I<NetworkManager>();

  late final _presenter = context.read<PageControllerBase>();

  late final _inputController =
      TextEditingController(text: _networkManager.selfId.name)
        ..addListener(_onInputChanged);

  late bool _canProceed = _inputController.value.text.length >= minNameLength;

  @override
  void dispose() {
    _inputController
      ..removeListener(_onInputChanged)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => StepperPage(
        stepCurrent: _presenter.currentPage,
        stepsCount: _presenter.stepsCount,
        title: 'Create a Device Name',
        subtitle: 'This is a name for identifying the device in splitting and '
            'restoring your Recovery Phrase. Make sure it is easily recognizable.',
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: TextField(
              maxLength: maxNameLength,
              controller: _inputController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                labelText: ' Device name ',
                helperText:
                    'e.g., Jason’s Phone or Jason Cooper, not “My Phone”',
              ),
            ),
          ),
        ],
        topButton: FilledButton(
          onPressed: _canProceed
              ? () async {
                  await _networkManager.setDeviceName(_inputController.text);
                  _presenter.nextPage();
                }
              : null,
          child: const Text('Continue'),
        ),
        bottomButton: const DiscardButton(),
      );

  void _onInputChanged() {
    final value = _inputController.value.text;
    if (value.length >= minNameLength && !_canProceed) {
      setState(() => _canProceed = !_canProceed);
    } else if (value.length < minNameLength && _canProceed) {
      setState(() => _canProceed = !_canProceed);
    }
  }
}
