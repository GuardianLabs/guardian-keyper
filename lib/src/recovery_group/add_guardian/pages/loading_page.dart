import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// import '../../../theme_data.dart';
// import '../../../widgets/common.dart';

import '../add_guardian_controller.dart';
// import '../../recovery_group_controller.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AddGuardianController>(context);
    return FutureBuilder(
      future: Future.delayed(const Duration(seconds: 1), state.nextScreen),
      builder: (context, snapshot) {
        state.guardianName = 'Phone name ' + DateTime.now().second.toString();
        return const Center(child: CircularProgressIndicator.adaptive());
      },
    );
  }
}
