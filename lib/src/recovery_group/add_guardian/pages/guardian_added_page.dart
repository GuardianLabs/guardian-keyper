import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../theme_data.dart';
import '../../../widgets/common.dart';
import '../../recovery_group_model.dart';
import '../add_guardian_view.dart';

import '../add_guardian_controller.dart';
import '../../recovery_group_controller.dart';

class GuardianAddedPage extends StatelessWidget {
  const GuardianAddedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AddGuardianController>(context);
    final recoveryGroupController =
        Provider.of<RecoveryGroupController>(context);
    final code = '0x' +
        state.guardian.code.substring(0, 10) +
        '...' +
        state.guardian.code.substring(state.guardian.code.length - 10);
    return Column(
      children: [
        // Header
        HeaderBar(
          title: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Recovery Group'),
              Text(state.group.name),
            ],
          ),
          // backButton: HeaderBarBackButton(onPressed: state.previousScreen),
          closeButton: const HeaderBarCloseButton(),
        ),
        // Body
        const Padding(
          padding: EdgeInsets.only(top: 20),
          child: CircleAvatar(backgroundColor: clIndigo700, radius: 40),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: RichText(
            textAlign: TextAlign.center,
            text: const TextSpan(
              children: <TextSpan>[
                TextSpan(text: 'Guardian added'),
                // TextSpan(text: 'successfuly', style: TextStyle(color: clBlue)),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: GuardianListTileWidget(
            name: state.guardian.name,
            code: code,
            tag: state.guardian.tag,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              color: clIndigo700,
            ),
            child: Column(
              children: [
                const Text('Guardians Added'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (var i = 0; i < state.group.size; i++)
                      Padding(
                        padding: const EdgeInsets.all(5),
                        child: CircleAvatar(
                          foregroundColor: clWhite,
                          backgroundColor: state.group.guardians.length > i
                              ? clGreen
                              : clIndigo500,
                          child: const Icon(Icons.health_and_safety_outlined),
                        ),
                      ),
                  ],
                ),
                const Text(
                    'In order to addsecret you need to add from 3 to 5 guardians to the group.'),
                OutlinedButton(
                  child: const Text('Add Guardian'),
                  onPressed: () {
                    Navigator.popAndPushNamed(
                      context,
                      AddGuardianView.routeName,
                      arguments: state.group,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        Expanded(child: Container()),
        // Footer
        if (state.group.status != RecoveryGroupStatus.notCompleted)
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: FooterButton(
              text: 'Add Secret',
              onPressed: Navigator.of(context).pop,
              // onPressed: () => state.gotoScreen(2),
            ),
          ),
        Container(height: 50),
      ],
    );
  }
}
