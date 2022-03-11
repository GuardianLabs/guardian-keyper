import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/model/p2p_model.dart';
import '../add_guardian_controller.dart';
import '../../recovery_group_controller.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AddGuardianController>(context);
    final controller = Provider.of<RecoveryGroupController>(context);

    switch (controller.authRequestStatus) {
      case RequestStatus.idle:
        controller.sendAuthRequest(QRCode.fromBase64(
            context.read<AddGuardianController>().guardianCode));
        break;
      case RequestStatus.sending:
        return const Center(child: CircularProgressIndicator.adaptive());
      case RequestStatus.sent:
        controller.resetAuthRequest();
        state.guardianName = 'Phone name ' + DateTime.now().second.toString();
        state.nextScreen();
        break;
      case RequestStatus.timeout:
        controller.resetAuthRequest();
        state.previousScreen(); // TBD: show error
        break;
      default:
    }
    return const Center();
  }
}
