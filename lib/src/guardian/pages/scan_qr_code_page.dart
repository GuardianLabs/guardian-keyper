import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '/src/core/model/p2p_model.dart';
import '/src/core/widgets/common.dart';
import '../guardian_model.dart';
import 'confirmation_page.dart';

class ScanQRCodePage extends StatelessWidget {
  final SecretShard secretShard;

  const ScanQRCodePage({Key? key, required this.secretShard}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            const HeaderBar(
              caption: 'Scan QR Code',
              closeButton: HeaderBarCloseButton(),
            ),
            // Body
            Expanded(child: Container()),
            Align(
                alignment: Alignment.center,
                child: SizedBox(
                  height: 200,
                  width: 200,
                  child: MobileScanner(
                    allowDuplicates: false,
                    onDetect: (barcode, args) {
                      if (barcode.rawValue == null ||
                          barcode.rawValue!.isEmpty) {
                        return;
                      }
                      final qrCode = QRCode.fromBase64(barcode.rawValue!);
                      if (qrCode.type != MessageType.takeOwnership) return;
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        maintainState: false,
                        builder: (_) => ConfirmationPage(
                          secretShard: secretShard,
                          qrCode: qrCode,
                        ),
                      ));
                    },
                  ),
                )),
            // Footer
            Expanded(child: Container()),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(bottom: 40),
              child: const Text('Upload QR Code'),
            ),
          ],
        ),
      ),
    );
  }
}
