import 'package:flutter/material.dart';

import '/src/core/model/core_model.dart';

import '../add_guardian_controller.dart';
import '../../widgets/get_qrcode_widget.dart';

class ScanQRCodePage extends StatelessWidget {
  const ScanQRCodePage({super.key});

  @override
  Widget build(BuildContext context) => GetQRCodeWidget(
        resultCallback: (qrCode) {
          if (qrCode.code == MessageCode.createGroup) {
            context.read<AddGuardianController>().qrCode = qrCode;
          }
        },
      );
}
