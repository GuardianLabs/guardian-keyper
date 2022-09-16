import 'package:flutter/material.dart';

import '../restore_group_controller.dart';
import '../../widgets/get_qrcode_widget.dart';

class ScanQRCodePage extends StatelessWidget {
  const ScanQRCodePage({super.key});

  @override
  Widget build(BuildContext context) => GetQRCodeWidget(
        resultCallback: context.read<RestoreGroupController>().setQRCode,
      );
}
