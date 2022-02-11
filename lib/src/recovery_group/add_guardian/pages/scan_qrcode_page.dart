import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../../theme_data.dart';
import '../../../widgets/common.dart';

import '../add_guardian_controller.dart';

class ScanQRCodePage extends StatefulWidget {
  const ScanQRCodePage({Key? key}) : super(key: key);

  @override
  State<ScanQRCodePage> createState() => _ScanQRCodePageState();
}

class _ScanQRCodePageState extends State<ScanQRCodePage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (scanData.code == null || scanData.code!.isEmpty) return;
      final state = context.read<AddGuardianController>();
      state.guardianCode = scanData.code!;
      state.nextScreen();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AddGuardianController>(context);
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
              child: QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
              ),
            )),
        Expanded(
            child: TextButton(
          child: const Text('Create random code'),
          onPressed: () {
            const chars = '0123456789ABCDEF';
            final random = Random();
            state.guardianCode = String.fromCharCodes(Iterable.generate(
                64, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
            state.nextScreen();
          },
        )),
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
