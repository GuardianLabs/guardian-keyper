import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '/src/core/theme_data.dart';
import '/src/core/widgets/common.dart';
import '../add_guardian_controller.dart';

class ScanQRCodePage extends StatelessWidget {
  const ScanQRCodePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
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
                  if (barcode.rawValue == null || barcode.rawValue!.isEmpty) {
                    return;
                  }
                  final state = context.read<AddGuardianController>();
                  state.guardianCode = barcode.rawValue!;
                  state.nextScreen();
                },
              ),
            )),
        Expanded(child: Container()),
        Padding(
          padding: const EdgeInsets.only(left: 95, right: 95),
          child: Container(
            height: 50,
            color: clIndigo700,
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.share_outlined),
                Text('   Share app'),
              ],
            ),
          ),
        ),
        Container(
          height: 50,
          alignment: Alignment.center,
          child: const Text('Upload QR Code'),
        ),
      ],
    );
  }
}
