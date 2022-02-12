import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// import '../../widgets/icon_of.dart';
import '../../widgets/common.dart';

// import '../recovery_group_model.dart';
import '../recovery_group_controller.dart';

class RecoveryGroupAddSecretView extends StatelessWidget {
  const RecoveryGroupAddSecretView({
    Key? key,
    required this.recoveryGroupName,
  }) : super(key: key);

  static const routeName = '/recovery_group_add_secret';

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
                child: Text('Add secret'),
              ),
              backButton: HeaderBarBackButton(),
              closeButton: HeaderBarCloseButton(),
            ),
            Expanded(child: Center(child: Text(recoveryGroup.name))),
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
