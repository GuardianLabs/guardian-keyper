import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '/src/core/theme_data.dart';
import '/src/core/widgets/common.dart';
import '/src/guardian/guardian_controller.dart';

class ShowQRCodePage extends StatelessWidget {
  const ShowQRCodePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<GuardianController>(context);
    final q = MediaQuery.of(context).size.height > heightSmall ? 1 : 2;
    return Scaffold(
      primary: true,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            const HeaderBar(
              title: HeaderBarTitleLogo(),
              closeButton: HeaderBarCloseButton(),
            ),
            // Body
            Padding(
              padding: EdgeInsets.only(top: 80 / (q * 2)),
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: q * 40),
                child: QrImage(
                    foregroundColor: Colors.white,
                    data: controller.getQRCode().toString()),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 40 / q),
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
            Expanded(child: Container()),
            Padding(
              padding: EdgeInsets.only(bottom: 32 / q),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.share),
                style: const ButtonStyle().merge(buttonStyleSecondary),
                label: Text('Share My QR Code', style: textStylePoppinsBold16),
                onPressed: () {},
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 48 / q),
              child: TextButton(
                onPressed: null,
                child: Text(
                  'Download QR Code',
                  style: textStylePoppinsBold16Blue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
