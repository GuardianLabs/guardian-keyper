import 'package:mobile_scanner/mobile_scanner.dart';

import '/src/core/app/consts.dart';
import '/src/core/ui/widgets/common.dart';

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
    final scanAreaSize = size.width * 0.66;
    _scanWindow = Rect.fromCenter(
      center: size.center(Offset.zero),
      width: scanAreaSize,
      height: scanAreaSize,
    );
  }

  @override
  Widget build(final BuildContext context) => ScaffoldSafe(
        child: Stack(
          fit: StackFit.expand,
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
