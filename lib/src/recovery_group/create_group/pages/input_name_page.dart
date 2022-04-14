import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/utils.dart';
import '../../../core/theme_data.dart';
import '../../../core/widgets/common.dart';

import '../../add_guardian/add_guardian_view.dart';
import '../../recovery_group_model.dart';
import '../create_group_controller.dart';
import '../../recovery_group_controller.dart';

class InputNamePage extends StatelessWidget {
  const InputNamePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<CreateGroupController>(context);
    final recoveryGroups =
        Provider.of<RecoveryGroupController>(context, listen: false).groups;
    return Column(
      children: [
        // Header
        HeaderBar(
          caption: 'Add Name',
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
                TextSpan(text: 'Create a '),
                TextSpan(text: 'name', style: TextStyle(color: clBlue)),
                TextSpan(text: ' for your\n recovery group'),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
          child: TextField(
            restorationId: 'RecoveryGroupNameInput',
            keyboardType: TextInputType.name,
            onChanged: (value) {
              state.groupName = value;
              if (recoveryGroups.containsKey(value)) {
                state.groupNameError = 'Name already used!';
              } else {
                state.groupNameError = null;
              }
            },
            decoration: InputDecoration(
              border: Theme.of(context).inputDecorationTheme.border,
              filled: Theme.of(context).inputDecorationTheme.filled,
              fillColor: Theme.of(context).inputDecorationTheme.fillColor,
              labelText: 'GROUP NAME',
              errorText: state.groupNameError,
            ),
          ),
        ),
        Expanded(child: Container()),
        // Footer
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: PrimaryTextButton(
            text: 'Continue',
            onPressed: state.groupName.isEmpty || state.groupNameError != null
                ? null
                : () async {
                    final newGroup = RecoveryGroupModel(
                      id: GroupID(getRandomBytes(8)),
                      name: state.groupName,
                      type: state.groupType!,
                    );
                    try {
                      await context
                          .read<RecoveryGroupController>()
                          .addGroup(newGroup);
                    } on RecoveryGroupAlreadyExists {
                      state.groupNameError =
                          RecoveryGroupAlreadyExists.description;
                      return;
                    }
                    Navigator.popAndPushNamed(
                      context,
                      AddGuardianView.routeNameShowLastPage,
                      arguments: state.groupName,
                    );
                  },
          ),
        ),
        Container(height: 50),
      ],
    );
  }
}
