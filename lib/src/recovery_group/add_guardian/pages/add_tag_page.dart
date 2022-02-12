import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../theme_data.dart';
import '../../../widgets/common.dart';

import '../../recovery_group_model.dart';
import '../add_guardian_controller.dart';
import '../../recovery_group_controller.dart';

class AddTagPage extends StatelessWidget {
  const AddTagPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AddGuardianController>(context);
    return Column(
      children: [
        // Header
        HeaderBar(
          caption: 'Add Guardian',
          backButton: HeaderBarBackButton(onPressed: state.previousScreen),
          closeButton: const HeaderBarCloseButton(),
        ),
        // Body
        Padding(
          padding: const EdgeInsets.only(top: 60),
          child: RichText(
            textAlign: TextAlign.center,
            text: const TextSpan(
              children: <TextSpan>[
                TextSpan(text: 'The wallet was scanned\n'),
                TextSpan(text: 'successfuly', style: TextStyle(color: clBlue)),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: GuardianListTileWidget(
            name: state.guardianName,
            code: state.guardianCodeHex,
            tag: state.guardianTag,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
          child: TextField(
            restorationId: 'RecoveryGroupTagInput',
            keyboardType: TextInputType.name,
            onChanged: (value) => state.guardianTag = value,
            decoration: InputDecoration(
              border: Theme.of(context).inputDecorationTheme.border,
              filled: Theme.of(context).inputDecorationTheme.filled,
              fillColor: Theme.of(context).inputDecorationTheme.fillColor,
              labelText: 'ADD TAG',
              helperText:
                  'You can create a tag for this device to not forget it',
            ),
          ),
        ),
        Expanded(child: Container()),
        // Footer
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: FooterButton(
            text: 'Continue',
            onPressed: () async {
              await context.read<RecoveryGroupController>().addGuardian(
                    state.groupName,
                    RecoveryGroupGuardianModel(
                      name: state.guardianName,
                      code: state.guardianCode,
                      tag: state.guardianTag,
                    ),
                  );
              state.showLastPage
                  ? state.nextScreen()
                  : Navigator.of(context).pop();
            },
          ),
        ),
        Container(height: 50),
      ],
    );
  }
}
