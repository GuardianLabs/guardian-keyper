import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:vector_graphics/vector_graphics.dart';

import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/ui/utils/screen_size.dart';

class QRCodeScanScreen extends StatefulWidget {
  const QRCodeScanScreen({super.key});

  @override
  State<QRCodeScanScreen> createState() => _QRCodeScanScreenState();
}

class _QRCodeScanScreenState extends State<QRCodeScanScreen> {
  bool _hasResult = false;
  late Rect _scanWindow;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final size = MediaQuery.of(context).size;
    final scanAreaSize = switch (ScreenSize.get(size)) {
      ScreenSmall _ => size.width * 0.7,
      ScreenMedium _ => size.width * 0.7,
      ScreenLarge _ => size.width * 0.6,
      ScreenBig _ => size.width * 0.5,
    };
    _scanWindow = Rect.fromCenter(
      center: size.center(Offset.zero),
      width: scanAreaSize,
      height: scanAreaSize,
    );
  }

  @override
  Widget build(BuildContext context) => ScaffoldSafe(
        child: Stack(
          children: [
            MobileScanner(
              scanWindow: _scanWindow,
              onDetect: (BarcodeCapture captured) {
                if (captured.barcodes.isEmpty) return;
                if (_hasResult) return;
                if (context.mounted) {
                  _hasResult = true;
                  Navigator.of(context)
                      .pop<String?>(captured.barcodes.first.rawValue);
                }
              },
            ),
            CustomPaint(painter: _ScannerOverlay(scanWindow: _scanWindow)),
            Positioned.fromRect(
              rect: _scanWindow,
              child: SizedBox(
                height: _scanWindow.height,
                width: _scanWindow.width,
                child: const SvgPicture(
                  AssetBytesLoader('assets/images/frame.svg.vec'),
                ),
              ),
            ),
            const Column(
              children: [
                // Header
                HeaderBar(
                  isTransparent: true,
                  caption: 'Scan the QR Code',
                  closeButton: HeaderBarCloseButton(),
                ),
              ],
            ),
          ],
        ),
      );
}

class _ScannerOverlay extends CustomPainter {
  final Rect scanWindow;

  const _ScannerOverlay({required this.scanWindow});

  @override
  bool shouldRepaint(_) => false;

  @override
  void paint(Canvas canvas, Size size) => canvas.drawPath(
        Path.combine(
          PathOperation.difference,
          Path()..addRect(Rect.largest),
          Path()..addRect(scanWindow),
        ),
        Paint()
          ..color = clIndigo900.withOpacity(0.5)
          ..style = PaintingStyle.fill
          ..blendMode = BlendMode.dstOut,
      );
}
