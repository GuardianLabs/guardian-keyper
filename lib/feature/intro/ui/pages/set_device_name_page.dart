import 'package:flutter_svg/svg.dart';
import 'package:vector_graphics/vector_graphics_compat.dart';

import 'package:guardian_keyper/consts.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';

import '../intro_presenter.dart';

class SetDeviceNamePage extends StatelessWidget {
  const SetDeviceNamePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final presenter = context.read<IntroPresenter>();
    return ListView(
      padding: paddingAll20,
      children: [
        const Padding(
          padding: paddingV20,
          child: SvgPicture(
            AssetBytesLoader('assets/images/logo.svg.vec'),
            height: 80,
            width: 80,
          ),
        ),
        Padding(
          padding: paddingV20,
          child: Text(
            'Create your Guardian name',
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge,
          ),
        ),
        Padding(
          padding: paddingV20,
          child: TextFormField(
            autofocus: true,
            initialValue: presenter.deviceName,
            onChanged: (value) => presenter.deviceName = value,
            keyboardType: TextInputType.text,
            maxLength: maxNameLength,
            decoration: const InputDecoration(
              labelText: ' Guardian name ',
              helperText: 'Minimum $minNameLength characters',
            ),
          ),
        ),
        Padding(
          padding: paddingV20,
          child: Consumer<IntroPresenter>(
            builder: (_, presenter, ___) => FilledButton(
              onPressed:
                  presenter.canSaveName ? presenter.saveDeviceName : null,
              child: const Text('Proceed'),
            ),
          ),
        ),
      ],
    );
  }
}
