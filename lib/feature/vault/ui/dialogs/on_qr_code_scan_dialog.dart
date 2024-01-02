import 'package:mobile_scanner/mobile_scanner.dart';

import 'package:guardian_keyper/ui/widgets/common.dart';

class OnQrCodeScanDialog extends StatefulWidget {
  static const route = '/qrcode/scan';

  static Future<String?> show(
    BuildContext context, {
    required String caption,
  }) =>
      Navigator.of(context).push(MaterialPageRoute(
        fullscreenDialog: true,
        settings: const RouteSettings(name: route),
        builder: (_) => OnQrCodeScanDialog(caption: caption),
      ));

  const OnQrCodeScanDialog({
    required this.caption,
    super.key,
  });

  final String caption;

  @override
  State<OnQrCodeScanDialog> createState() => _OnQrCodeScanDialogState();
}

class _OnQrCodeScanDialogState extends State<OnQrCodeScanDialog> {
  bool _hasResult = false;
  late Rect _scanWindow;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final size = MediaQuery.of(context).size;
    final scanAreaSize = size.width / 2;
    _scanWindow = Rect.fromCenter(
      center: size.center(Offset.zero),
      width: scanAreaSize,
      height: scanAreaSize,
    );
  }

  @override
  Widget build(BuildContext context) => Stack(
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
          CustomPaint(painter: _ScannerOverlay(frame: _scanWindow)),
          // Header
          SafeArea(
            child: HeaderBar(
              isTransparent: true,
              caption: widget.caption,
              rightButton: const HeaderBarButton.close(),
            ),
          ),
        ],
      );
}

class _ScannerOverlay extends CustomPainter {
  _ScannerOverlay({required this.frame});

  final Rect frame;

  final _framePaint = Paint()
    ..color = Colors.white
    ..strokeCap = StrokeCap.round
    ..strokeWidth = 8;

  final _maskPaint = Paint()
    ..color = Colors.black54
    ..style = PaintingStyle.fill
    ..blendMode = BlendMode.dstOut;

  late final _maskPath = Path.combine(
    PathOperation.difference,
    Path()..addRect(Rect.largest),
    Path()..addRect(frame),
  );

  late final _frameSize = frame.height / 5;

  late final _leftTop = Offset(frame.left, frame.top);
  late final _leftTopH = Offset(frame.left + _frameSize, frame.top);
  late final _leftTopV = Offset(frame.left, frame.top + _frameSize);

  late final _rightTop = Offset(frame.right, frame.top);
  late final _rightTopH = Offset(frame.right - _frameSize, frame.top);
  late final _rightTopV = Offset(frame.right, frame.top + _frameSize);

  late final _leftBottom = Offset(frame.left, frame.bottom);
  late final _leftBottomH = Offset(frame.left + _frameSize, frame.bottom);
  late final _leftBottomV = Offset(frame.left, frame.bottom - _frameSize);

  late final _rightBottom = Offset(frame.right, frame.bottom);
  late final _rightBottomH = Offset(frame.right - _frameSize, frame.bottom);
  late final _rightBottomV = Offset(frame.right, frame.bottom - _frameSize);

  @override
  bool shouldRepaint(_) => false;

  @override
  void paint(Canvas canvas, Size size) => canvas
    ..drawPath(_maskPath, _maskPaint)
    ..drawLine(_leftTop, _leftTopH, _framePaint)
    ..drawLine(_leftTop, _leftTopV, _framePaint)
    ..drawLine(_rightTop, _rightTopH, _framePaint)
    ..drawLine(_rightTop, _rightTopV, _framePaint)
    ..drawLine(_leftBottom, _leftBottomH, _framePaint)
    ..drawLine(_leftBottom, _leftBottomV, _framePaint)
    ..drawLine(_rightBottom, _rightBottomH, _framePaint)
    ..drawLine(_rightBottom, _rightBottomV, _framePaint);
}
