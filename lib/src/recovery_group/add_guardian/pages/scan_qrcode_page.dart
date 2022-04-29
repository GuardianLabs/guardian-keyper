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
    final size = MediaQuery.of(context).size.width * 0.66;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Header
        const HeaderBar(
          caption: 'Scan QR Code',
          closeButton: HeaderBarCloseButton(),
        ),
        // Body
        SizedBox(
          height: size,
          width: size,
          child: MobileScanner(
            allowDuplicates: false,
            onDetect: (barcode, args) {
              if (barcode.rawValue != null && barcode.rawValue!.isNotEmpty) {
                final state = context.read<AddGuardianController>();
                state.guardianCode = barcode.rawValue!;
                state.nextScreen();
              }
            },
          ),
        ),
        Padding(
          padding: paddingFooter,
          child: Text('Upload QR Code', style: textStylePoppinsBold16Blue),
        ),
      ],
    );
  }
}
