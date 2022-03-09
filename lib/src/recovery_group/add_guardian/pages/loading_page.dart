import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/model/qr_code_model.dart';
import '../add_guardian_controller.dart';
import '../../recovery_group_controller.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AddGuardianController>(context);
    final controller = Provider.of<RecoveryGroupController>(context);

    switch (controller.authRequestStatus) {
      case AuthRequestStatus.idle:
        controller.sendAuthRequest(QRCodeModel.fromString(
            context.read<AddGuardianController>().guardianCode));
        break;
      case AuthRequestStatus.sending:
        return const Center(child: CircularProgressIndicator.adaptive());
      case AuthRequestStatus.sent:
        controller.resetAuthRequest();
        state.guardianName = 'Phone name ' + DateTime.now().second.toString();
        state.nextScreen();
        break;
      case AuthRequestStatus.timeout:
        controller.resetAuthRequest();
        state.previousScreen(); // TBD: show error
        break;
      default:
    }
    return const Center();
  }
}
