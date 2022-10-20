import '/src/core/theme/theme.dart';
import '/src/core/widgets/common.dart';

import '../add_guardian_controller.dart';
import '../../widgets/guardian_tile_widget.dart';

class AddTagPage extends StatefulWidget {
  const AddTagPage({super.key});

  @override
  State<AddTagPage> createState() => _AddTagPageState();
}

class _AddTagPageState extends State<AddTagPage> {
  String _tag = '';

  @override
  Widget build(BuildContext context) {
    final controller = context.read<AddGuardianController>();
    return Column(
      children: [
        // Header
        const HeaderBar(
          caption: 'Adding a Guardian',
          closeButton: HeaderBarCloseButton(),
        ),
        // Body
        Expanded(
          child: ListView(
            primary: true,
            shrinkWrap: true,
            padding: paddingH20,
            children: [
              Padding(
                padding: paddingTop32,
                child: Text(
                  'Guardian identified',
                  textAlign: TextAlign.center,
                  style: textStylePoppins620,
                ),
              ),
              Padding(
                padding: paddingTop12,
                child: Text(
                  'We advise you to add a tag name to remember '
                  'the owner of this device in case of a recovery.',
                  textAlign: TextAlign.center,
                  style: textStyleSourceSansPro414Purple,
                ),
              ),
              Padding(
                padding: paddingTop32,
                child: GuardianTileWidget(
                  isSuccess: true,
                  guardian: controller.qrCode!.peerId,
                  tag: _tag,
                ),
              ),
              Padding(
                padding: paddingTop32,
                child: TextFormField(
                  keyboardType: TextInputType.name,
                  maxLength: controller.globals.maxNameLength,
                  onChanged: (value) => setState(() => _tag = value),
                  decoration: const InputDecoration(
                    labelText: ' Tag name ',
                    helperText: 'You can leave it blank',
                  ),
                ),
              ),
              // Footer
              Padding(
                padding: paddingTop32,
                child: PrimaryButton(
                  text: 'Continue',
                  onPressed: () async {
                    await controller.addGuardian(
                      controller.groupId,
                      controller.qrCode!.peerId,
                      _tag,
                    );
                    if (mounted) {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(buildSnackBar(
                        text: 'You have successfully added '
                            '${controller.qrCode!.peerId.name} '
                            'as a Guardian for ${controller.groupId.name}.',
                      ));
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
