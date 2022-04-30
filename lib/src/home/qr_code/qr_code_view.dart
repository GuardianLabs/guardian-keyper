import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/src/core/theme_data.dart';
import '/src/core/pages/qr_code_page.dart';
import '/src/guardian/guardian_controller.dart';

class ShowQRCodeView extends StatelessWidget {
  const ShowQRCodeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<GuardianController>(context, listen: false);
    return Scaffold(
      primary: true,
      body: SafeArea(
        child: QRCodePage(
          qrCode: controller.getQRCode().toString(),
          child: RichText(
            textAlign: TextAlign.center,
            softWrap: true,
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: 'Share your QR code with other\nGuardians.',
                  style: textStyleSourceSansProRegular16,
                ),
                TextSpan(
                  text: ' Learn more',
                  style: textStyleSourceSansProBold16Blue,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
