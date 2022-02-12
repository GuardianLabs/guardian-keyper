import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/icon_of.dart';
import '../../widgets/common.dart';

// import '../recovery_group_model.dart';
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
              // backButton: HeaderBarBackButton(),
              closeButton: HeaderBarCloseButton(),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  SimpleCard(
                    caption: recoveryGroup.name,
                    text: recoveryGroup.type.toString(),
                    leading: const IconOf.group(),
                  ),
                ],
              ),
            ),
            // Footer
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: FooterButton(text: 'Continue', onPressed: () {}),
            ),
            Container(height: 50),
          ],
        ));
  }
}
