import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/src/core/theme_data.dart';
import '/src/core/pages/qr_code_page.dart';

import '../../recovery_group_controller.dart';

class ShowQRCodePage extends StatelessWidget {
  const ShowQRCodePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<RecoveryGroupController>(context);
    return QRCodePage(
      qrCode: controller.getQRCode().toString(),
      child: Text(
        'Please show this QR code to\nyour Guardians',
        style: textStyleSourceSansProBold16,
        textAlign: TextAlign.center,
      ),
    );
  }
}
