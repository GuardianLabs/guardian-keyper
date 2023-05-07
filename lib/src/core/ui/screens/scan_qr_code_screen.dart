import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:vector_graphics/vector_graphics.dart';

import 'package:guardian_keyper/src/core/consts.dart';
import 'package:guardian_keyper/src/core/ui/utils.dart';
import 'package:guardian_keyper/src/core/ui/widgets/common.dart';

class ScanQRCodeScreen extends StatefulWidget {
  static const routeName = routeScanQrCode;

  static MaterialPageRoute<String?> getPageRoute(
          final RouteSettings settings) =>
      MaterialPageRoute<String?>(
        settings: settings,
        fullscreenDialog: true,
        builder: (_) => const ScanQRCodeScreen(),
      );

  const ScanQRCodeScreen({super.key});

  @override
  State<ScanQRCodeScreen> createState() => _ScanQRCodeScreenState();
}

class _ScanQRCodeScreenState extends State<ScanQRCodeScreen> {
  bool _hasResult = false;
  late Rect _scanWindow;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final size = MediaQuery.of(context).size;
    late final double scanAreaSize;
    switch (getScreenSize(size)) {
      case ScreenSize.big:
        scanAreaSize = size.width * 0.5;
        break;
      case ScreenSize.large:
        scanAreaSize = size.width * 0.6;
        break;
      case ScreenSize.medium:
        scanAreaSize = size.width * 0.7;
        break;
      case ScreenSize.small:
        scanAreaSize = size.width * 0.7;
        break;
    }
    _scanWindow = Rect.fromCenter(
      center: size.center(Offset.zero),
      width: scanAreaSize,
      height: scanAreaSize,
    );
  }

  @override
  Widget build(final BuildContext context) => ScaffoldSafe(
        child: Stack(
          // fit: StackFit.expand,
          children: [
            MobileScanner(
              fit: BoxFit.cover,
              scanWindow: _scanWindow,
              onDetect: (final BarcodeCapture captured) {
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
            Column(
              children: const [
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
  bool shouldRepaint(covariant final CustomPainter _) => false;

  @override
  void paint(final Canvas canvas, final Size size) => canvas.drawPath(
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
