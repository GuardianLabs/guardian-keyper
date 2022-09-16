import 'package:flutter/material.dart';

import '../add_guardian_controller.dart';
import '../../widgets/get_qrcode_widget.dart';

class ScanQRCodePage extends StatelessWidget {
  const ScanQRCodePage({super.key});

  @override
  Widget build(BuildContext context) => GetQRCodeWidget(
        resultCallback: context.read<AddGuardianController>().setQRCode,
      );
}
