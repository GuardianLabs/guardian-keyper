// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:qr_flutter/qr_flutter.dart';

// import '../settings/settings_controller.dart';
// import 'guardian_controller.dart';

// class GuardianView extends StatelessWidget {
//   const GuardianView({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final controller = Provider.of<GuardianController>(context);
//     switch (controller.processStatus) {
//       case ProcessingStatus.notInited:
//         return const Text('Not inited!');
//       case ProcessingStatus.inited:
//         return QrImage(
//             data: controller
//                 .getQRCode(context.read<SettingsController>().keyPair.publicKey)
//                 .toString());
//       case ProcessingStatus.waiting:
//         return const CircularProgressIndicator.adaptive();
//       case ProcessingStatus.finished:
//         return const Text('Success!');
//       case ProcessingStatus.error:
//         return const Text('Error!');
//     }
//   }
// }
