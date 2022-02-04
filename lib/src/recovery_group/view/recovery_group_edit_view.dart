import 'package:flutter/material.dart';

import '../../widgets/common.dart';

// import '../recovery_group_model.dart';

class RecoveryGroupEditView extends StatelessWidget {
  const RecoveryGroupEditView({Key? key}) : super(key: key);

  static const routeName = '/recovery_group_edit';
  // static const _paddingV5 = EdgeInsets.only(top: 5, bottom: 5);

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
              ),
            ),
            // Footer
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: FooterButton(text: 'Save', onPressed: () {}),
            ),
            Container(height: 50),
          ],
        ));
  }
}
