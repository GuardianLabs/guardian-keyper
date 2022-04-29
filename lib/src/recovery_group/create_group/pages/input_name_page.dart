import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/src/core/utils.dart';
import '/src/core/theme_data.dart';
import '/src/core/widgets/common.dart';

import '../../add_guardian/add_guardian_view.dart';
import '../../recovery_group_model.dart';
import '../../recovery_group_controller.dart';
import '../create_group_controller.dart';

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
        PaddingTop(
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: Theme.of(context).textTheme.headline6,
              children: const <TextSpan>[
                TextSpan(text: 'Create a '),
                TextSpan(text: 'name', style: TextStyle(color: clBlue)),
                TextSpan(text: ' for your\n recovery group'),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
          child: TextField(
            autofocus: true,
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              labelText: ' GROUP NAME ',
              errorText: state.groupNameError,
            ),
            onChanged: (value) {
              state.groupName = value;
              state.groupNameError = recoveryGroups.containsKey(value)
                  ? 'Name already used!'
                  : null;
            },
          ),
        ),
        Expanded(child: Container()),
        // Footer
        Padding(
          padding: paddingFooter,
          child: PrimaryButtonBig(
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
      ],
    );
  }
}
