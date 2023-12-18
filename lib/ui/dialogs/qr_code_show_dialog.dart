import 'package:get_it/get_it.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vector_graphics/vector_graphics.dart';

import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/data/services/platform_service.dart';

class QRCodeShowDialog extends StatefulWidget {
  static const route = '/qrcode/show';

  static Future<void> show(
    BuildContext context, {
    required String qrCode,
    required String caption,
    required String title,
    required String subtitle,
  }) =>
      Navigator.of(context).push(MaterialPageRoute(
        fullscreenDialog: true,
        settings: _routeSettings,
        builder: (_) => QRCodeShowDialog(
          qrCode: qrCode,
          caption: caption,
          title: title,
          subtitle: subtitle,
        ),
      ));

  static const _routeSettings = RouteSettings(name: route);

  const QRCodeShowDialog({
    required this.qrCode,
    required this.caption,
    required this.title,
    required this.subtitle,
    super.key,
  });

  final String qrCode;
  final String caption;
  final String title;
  final String subtitle;

  @override
  State<QRCodeShowDialog> createState() => _QRCodeShowDialogState();
}

class _QRCodeShowDialogState extends State<QRCodeShowDialog> {
  late final _colorScheme = Theme.of(context).colorScheme;

  @override
  void initState() {
    super.initState();
    GetIt.I<PlatformService>().wakelockEnable();
  }

  @override
  void dispose() {
    GetIt.I<PlatformService>().wakelockDisable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ScaffoldSafe(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            HeaderBar(
              caption: widget.caption,
              backButton: const HeaderBarBackButton(),
              closeButton: HeaderBarCloseButton(
                onPressed: () =>
                    Navigator.of(context).popUntil((r) => r.isFirst),
              ),
            ),
            // Body
            PageTitle(
              title: widget.title,
              subtitle: widget.subtitle,
            ),
            // QR Code
            Container(
              margin: paddingAll20,
              padding: paddingAll20,
              decoration: BoxDecoration(
                borderRadius: borderRadius8,
                color: _colorScheme.surface,
              ),
              width: double.infinity,
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxHeight: 400,
                  maxWidth: 400,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    QrImageView(
                      data: widget.qrCode,
                      errorCorrectionLevel: QrErrorCorrectLevel.M,
                      dataModuleStyle: QrDataModuleStyle(
                        color: _colorScheme.surface,
                        dataModuleShape: QrDataModuleShape.square,
                      ),
                      eyeStyle: QrEyeStyle(
                        color: _colorScheme.surface,
                        eyeShape: QrEyeShape.square,
                      ),
                      padding: paddingAll20,
                    ),
                    LayoutBuilder(builder: (_, constraints) {
                      final logoSize = constraints.biggest.shortestSide / 4;
                      return Container(
                        constraints: BoxConstraints.expand(
                          height: logoSize,
                          width: logoSize,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          color: _colorScheme.surface,
                        ),
                        padding: paddingAll8,
                        child: const SvgPicture(
                          AssetBytesLoader('assets/images/logo.svg.vec'),
                          fit: BoxFit.cover,
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
            // Share Button
            Padding(
              padding: paddingAll8,
              child: Text(
                'Text Code',
                style: styleSourceSansPro414Purple,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: paddingH20,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      decoration: ShapeDecoration(
                        color: _colorScheme.surface,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: _colorScheme.secondary),
                          borderRadius: const BorderRadius.only(
                            topLeft: radius8,
                            bottomLeft: radius8,
                          ),
                        ),
                      ),
                      height: 48,
                      child: Padding(
                        padding: paddingAll8,
                        child: Text(
                          widget.qrCode,
                          style: styleSourceSansPro414Purple,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: ShapeDecoration(
                      color: _colorScheme.primary,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topRight: radius8,
                          bottomRight: radius8,
                        ),
                      ),
                    ),
                    height: 48,
                    child: Builder(
                      builder: (context) => IconButton(
                        icon: Transform.flip(
                          flipX: true,
                          child: const Icon(Icons.reply, size: 30),
                        ),
                        onPressed: () {
                          final box = context.findRenderObject() as RenderBox?;
                          GetIt.I<PlatformService>().share(
                            'This is a SINGLE-USE authentication token'
                            ' for Guardian Keyper. DO NOT REUSE IT! \n '
                            '${widget.qrCode}',
                            subject: 'Guardian Code',
                            sharePositionOrigin:
                                box!.localToGlobal(Offset.zero) & box.size,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}
