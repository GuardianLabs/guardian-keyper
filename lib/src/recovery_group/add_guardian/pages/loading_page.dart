import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/model/p2p_model.dart';
import '../add_guardian_controller.dart';
import '../../recovery_group_controller.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    super.initState();
    final controller = context.read<RecoveryGroupController>();
    controller.sendAuthRequest(
        QRCode.fromBase64(context.read<AddGuardianController>().guardianCode));
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AddGuardianController>(context);
    if (state.guardianName.isNotEmpty) {
      Future.delayed(const Duration(seconds: 1), state.nextScreen);
    }
    if (state.error != null) {
      return Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text('Error: ${state.error}'),
            Text('Stack Trace: ${state.stackTrace}'),
          ]);
    }
    return const Center(child: CircularProgressIndicator.adaptive());
  }
}
