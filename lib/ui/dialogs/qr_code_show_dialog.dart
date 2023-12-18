import 'package:get_it/get_it.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vector_graphics/vector_graphics.dart';

import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/ui/widgets/icon_of.dart';
import 'package:guardian_keyper/data/services/platform_service.dart';

class QRCodeShowDialog extends StatefulWidget {
  static const route = '/qrcode/show';

  static Future<void> show(
    BuildContext context, {
    required String qrCode,
    required String caption,
    required String subtitle,
  }) =>
      Navigator.of(context).push(MaterialPageRoute(
        fullscreenDialog: true,
        settings: _routeSettings,
        builder: (_) => QRCodeShowDialog(
          qrCode: qrCode,
          caption: caption,
          subtitle: subtitle,
        ),
      ));

  static Future<void> showAsReplacement(
    BuildContext context, {
    required String qrCode,
    required String caption,
    required String subtitle,
  }) =>
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        fullscreenDialog: true,
        settings: _routeSettings,
        builder: (_) => QRCodeShowDialog(
          qrCode: qrCode,
          caption: caption,
          subtitle: subtitle,
        ),
      ));

  static const _routeSettings = RouteSettings(name: route);

  const QRCodeShowDialog({
    required this.qrCode,
    required this.caption,
    required this.subtitle,
    super.key,
  });

  final String qrCode;
  final String caption;
  final String subtitle;

  @override
  State<QRCodeShowDialog> createState() => _QRCodeShowDialogState();
}

class _QRCodeShowDialogState extends State<QRCodeShowDialog> {
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
          children: [
            // Header
            HeaderBar(
              caption: widget.caption,
              closeButton: const HeaderBarCloseButton(),
            ),
            // Body
            PageTitle(
              title: 'Your one-time Code',
              subtitle: widget.subtitle,
            ),
            // QR Code
            Expanded(
              child: Padding(
                padding: paddingH20,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxHeight: 400,
                    maxWidth: 400,
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        decoration: boxDecoration,
                        child: QrImageView(
                          data: widget.qrCode,
                          errorCorrectionLevel: QrErrorCorrectLevel.M,
                          dataModuleStyle: const QrDataModuleStyle(
                            color: clPurpleLight,
                            dataModuleShape: QrDataModuleShape.square,
                          ),
                          eyeStyle: const QrEyeStyle(
                            color: clPurpleLight,
                            eyeShape: QrEyeShape.square,
                          ),
                          padding: paddingAll20,
                        ),
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
                            color: clSurface,
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
            ),
            // Share Button
            Container(
              padding: paddingAll20,
              width: double.infinity,
              child: Builder(
                builder: (context) => ElevatedButton.icon(
                  icon: const IconOf.share(
                    bgColor: clIndigo500,
                    size: 20,
                  ),
                  label: const Text('Share Code'),
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
      );
}
