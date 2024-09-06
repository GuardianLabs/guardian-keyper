import 'package:flutter_svg/svg.dart';
import 'package:vector_graphics/vector_graphics_compat.dart';

import 'package:guardian_keyper/ui/widgets/common.dart';

import 'package:guardian_keyper/feature/settings/ui/widgets/device_name_input.dart';

import '../intro_presenter.dart';

class SetDeviceNamePage extends StatelessWidget {
  const SetDeviceNamePage({super.key});

  @override
  Widget build(BuildContext context) => ListView(
        children: [
          const Padding(
            padding: paddingAllDefault,
            child: SvgPicture(
              AssetBytesLoader('assets/images/logo.svg.vec'),
              height: 80,
              width: 80,
            ),
          ),
          Padding(
            padding: paddingAllDefault,
            child: Text(
              'Create your Device name',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          DeviceNameInput(onProceed: context.read<IntroPresenter>().nextPage),
        ],
      );
}
