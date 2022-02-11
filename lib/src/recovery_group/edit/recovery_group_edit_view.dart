import 'package:flutter/material.dart';
import 'package:guardian_network/src/widgets/icon_of.dart';

import '../../widgets/common.dart';

import '../recovery_group_model.dart';

class RecoveryGroupEditView extends StatelessWidget {
  const RecoveryGroupEditView({
    Key? key,
    required this.recoveryGroup,
  }) : super(key: key);

  static const routeName = '/recovery_group_edit';
  // static const _paddingV5 = EdgeInsets.only(top: 5, bottom: 5);

  final RecoveryGroupModel recoveryGroup;

  @override
  Widget build(BuildContext context) {
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
