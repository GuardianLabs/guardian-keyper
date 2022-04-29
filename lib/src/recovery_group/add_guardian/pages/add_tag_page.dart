import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:p2plib/p2plib.dart' show PubKey;

import '/src/core/theme_data.dart';
import '/src/core/widgets/common.dart';
import '/src/recovery_group/widgets/guardian_tile_widget.dart';

import '../../recovery_group_model.dart';
import '../../recovery_group_controller.dart';
import '../add_guardian_controller.dart';

class AddTagPage extends StatelessWidget {
  const AddTagPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AddGuardianController>(context);
    final guardian = RecoveryGroupGuardianModel(
      name: state.guardianName,
      tag: state.guardianTag,
      pubKey: PubKey(state.guardianQRCode.pubKey),
      signPubKey: PubKey(state.guardianQRCode.signPubKey),
    );
    return Column(
      children: [
        // Header
        const HeaderBar(
          caption: 'Add Guardian',
          closeButton: HeaderBarCloseButton(),
        ),
        // Body
        Expanded(
          child: ListView(
            primary: true,
            shrinkWrap: true,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 60),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                          text: 'Guardian ', style: textStylePoppinsBold20),
                      TextSpan(
                        text: 'identified',
                        style: textStylePoppinsBold20Blue,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: paddingAll20,
                child: GuardianTileWidget(
                  guardian: guardian,
                  isHighlighted: true,
                ),
              ),
              Padding(
                padding: paddingAll20,
                child: TextField(
                  keyboardType: TextInputType.name,
                  onChanged: (value) => state.guardianTag = value,
                  decoration: const InputDecoration(labelText: 'ADD TAG'),
                ),
              ),
              const Padding(
                padding: paddingAll20,
                child: InfoPanel.info(
                    text: 'Please add a tag to name this Guardian device'),
              ),
            ],
          ),
        ),
        // Footer
        Padding(
          padding: paddingFooter,
          child: PrimaryButtonBig(
            text: 'Continue',
            onPressed: () async {
              await context
                  .read<RecoveryGroupController>()
                  .addGuardian(state.groupName, guardian);
              state.showLastPage
                  ? state.nextScreen()
                  : Navigator.of(context).pop();
            },
          ),
        ),
      ],
    );
  }
}
