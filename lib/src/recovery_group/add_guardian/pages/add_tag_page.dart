import '/src/core/theme_data.dart';
import '/src/core/widgets/common.dart';
import '/src/core/model/core_model.dart';

import '../add_guardian_controller.dart';
import '../../widgets/guardian_tile_widget.dart';

class AddTagPage extends StatelessWidget {
  const AddTagPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<AddGuardianController>(context);
    return Column(
      children: [
        // Header
        const HeaderBar(
          caption: 'Add Guardians',
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
                  guardian: GuardianModel(
                    name: controller.qrCode!.peerName,
                    tag: controller.guardianTag,
                    peerId: controller.qrCode!.peerId,
                  ),
                ),
              ),
              Padding(
                padding: paddingTop32,
                child: TextFormField(
                  keyboardType: TextInputType.name,
                  maxLength: controller.diContainer.globals.maxNameLength,
                  onChanged: (value) => controller.guardianTag = value,
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
                  onPressed: () async => Navigator.of(context)
                      .pop(await controller.addGuardianToGroup()),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
