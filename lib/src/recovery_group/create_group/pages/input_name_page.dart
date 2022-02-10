import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../theme_data.dart';
import '../../../widgets/common.dart';

// import '../../add_guardian/add_guardian_view.dart';
import '../create_group_controller.dart';
// import '../../recovery_group_controller.dart';

class InputNamePage extends StatelessWidget {
  const InputNamePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<CreateGroupController>(context);
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
            // autofocus: true,
            controller: TextEditingController(text: state.group.name),
            restorationId: 'RecoveryGroupNameInput',
            keyboardType: TextInputType.name,
            onChanged: (value) => state.groupName = value,
            decoration: InputDecoration(
              border: Theme.of(context).inputDecorationTheme.border,
              filled: Theme.of(context).inputDecorationTheme.filled,
              fillColor: Theme.of(context).inputDecorationTheme.fillColor,
              labelText: 'GROUP NAME',
              errorText: state.errName,
            ),
          ),
        ),
        Expanded(child: Container()),
        // Footer
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: FooterButton(
            text: 'Continue',
            onPressed: state.group.name.isEmpty
                ? null
                : () {
                    Navigator.pop(context, state.group);
                    // try {
                    //   context
                    //       .read<RecoveryGroupController>()
                    //       .addGroup(state.group);
                    // } on RecoveryGroupAlreadyExists {
                    //   state.errName = RecoveryGroupAlreadyExists.description;
                    //   return;
                    // }
                    // Navigator.popAndPushNamed(
                    //   context,
                    //   AddGuardianView.routeName,
                    //   arguments: state.group,
                    // );
                  },
          ),
        ),
        Container(height: 50),
      ],
    );
  }
}
