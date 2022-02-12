import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../theme_data.dart';
import '../../../widgets/common.dart';
import '../add_guardian_view.dart';
import '../../add_secret/add_secret_view.dart';

import '../../recovery_group_model.dart';
import '../add_guardian_controller.dart';
import '../../recovery_group_controller.dart';

class GuardianAddedPage extends StatelessWidget {
  const GuardianAddedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AddGuardianController>(context);
    final recoveryGroup =
        Provider.of<RecoveryGroupController>(context).groups[state.groupName]!;
    return Column(
      children: [
        // Header
        HeaderBar(
          title: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Recovery Group'),
              Text(state.groupName),
            ],
          ),
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
            name: state.guardianName,
            code: state.guardianCodeHex,
            tag: state.guardianTag,
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
                    for (var i = 0; i < recoveryGroup.size; i++)
                      Padding(
                        padding: const EdgeInsets.all(5),
                        child: CircleAvatar(
                          foregroundColor: clWhite,
                          backgroundColor: recoveryGroup.guardians.length > i
                              ? clGreen
                              : clIndigo500,
                          child: const Icon(Icons.health_and_safety_outlined),
                        ),
                      ),
                  ],
                ),
                Text(
                    'In order to addsecret you need to add from ${recoveryGroup.threshold} to ${recoveryGroup.size} guardians to the group.'),
                OutlinedButton(
                  child: const Text('Add Guardian'),
                  onPressed: recoveryGroup.guardians.length < recoveryGroup.size
                      ? () {
                          Navigator.popAndPushNamed(
                            context,
                            AddGuardianView.routeName + '/showLastPage',
                            arguments: state.groupName,
                          );
                        }
                      : null,
                ),
              ],
            ),
          ),
        ),
        Expanded(child: Container()),
        // Footer
        if (recoveryGroup.status != RecoveryGroupStatus.missed)
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: FooterButton(
              text: 'Add Secret',
              onPressed: () => Navigator.popAndPushNamed(
                context,
                RecoveryGroupAddSecretView.routeName,
                arguments: state.groupName,
              ),
            ),
          ),
        Container(height: 50),
      ],
    );
  }
}
