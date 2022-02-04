import 'package:flutter/material.dart';

import '../widgets/common.dart';
import 'view/recovery_group_edit_view.dart';
import 'recovery_group_model.dart';

final _groups = <RecoveryGroupModel>[
  const RecoveryGroupModel(groupName: 'Fake group 1'),
  const RecoveryGroupModel(groupName: 'Fake group 2'),
];

class RecoveryGroupView extends StatelessWidget {
  const RecoveryGroupView({Key? key}) : super(key: key);

  static const routeName = '/recovery_group';
  static const _paddingV5 = EdgeInsets.only(top: 5, bottom: 5);

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
                child: Text('My Recovery Groups'),
              ),
              backButton: HeaderBarBackButton(),
              closeButton: HeaderBarCloseButton(),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  for (final group in _groups)
                    Padding(
                      padding: _paddingV5,
                      child: ListTileButton(
                        text: group.groupName,
                        trailing: 'assets/images/icon_group.png',
                        onPressed: () => Navigator.pushNamed(
                            context, RecoveryGroupEditView.routeName,
                            arguments: group),
                      ),
                    )
                ],
              ),
            ),
            // Footer
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: FooterButton(text: 'Create new group', onPressed: () {}),
            ),
            Container(height: 50),
          ],
        ));
  }
}
