import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme_data.dart';
import '../../core/widgets/common.dart';
import '../add_guardian/add_guardian_view.dart';
import '../add_secret/add_secret_view.dart';

import '../recovery_group_controller.dart';

class RecoveryGroupEditView extends StatelessWidget {
  const RecoveryGroupEditView({
    Key? key,
    required this.recoveryGroupName,
  }) : super(key: key);

  static const routeName = '/recovery_group_edit';

  final String recoveryGroupName;

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<RecoveryGroupController>(context);
    final recoveryGroup = state.groups[recoveryGroupName]!;
    return Scaffold(
        primary: true,
        body: Column(
          children: [
            // Header
            const HeaderBar(
              title: Padding(
                padding: EdgeInsets.only(top: 55),
                child: Text('Edit Recovery Group'),
              ),
              backButton: HeaderBarBackButton(),
              // closeButton: HeaderBarCloseButton(),
            ),
            // Body
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'GUARDIANS',
                      style: Theme.of(context).textTheme.caption,
                    ),
                    Text(
                      '${recoveryGroup.guardians.length}/${recoveryGroup.size}',
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ]),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  for (var guardian in recoveryGroup.guardians.values)
                    GuardianListTileWidget(
                      name: guardian.name,
                      code: guardian.code,
                      tag: guardian.tag,
                      nameColor: guardian.code.isEmpty ? clRed : clWhite,
                      iconColor: guardian.code.isEmpty ? clRed : clGreen,
                      status: guardian.code.isEmpty ? clRed : clGreen,
                    ),
                  ListTile(
                    title: ElevatedButton(
                      child: const Text('Add Guardian'),
                      onPressed: recoveryGroup.isCompleted
                          ? null
                          : () => Navigator.of(context).pushNamed(
                              AddGuardianView.routeName,
                              arguments: recoveryGroupName),
                    ),
                  ),
                  if (!recoveryGroup.isMissed)
                    const ListTile(
                      title: ElevatedButton(
                        child: Text('Test Guardians (soon)'),
                        onPressed: null,
                      ),
                    ),
                ],
              ),
            ),
            // Footer
            if (!recoveryGroup.isMissed)
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: recoveryGroup.secrets.isEmpty
                    ? FooterButton(
                        text: 'Add Secret',
                        onPressed: () => Navigator.of(context).pushNamed(
                            RecoveryGroupAddSecretView.routeName,
                            arguments: recoveryGroupName))
                    : FooterButton(text: 'Secret Recovery', onPressed: () {}),
              ),
            Container(height: 50),
          ],
        ));
  }
}
