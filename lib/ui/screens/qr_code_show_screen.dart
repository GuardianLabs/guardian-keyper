import 'package:get_it/get_it.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vector_graphics/vector_graphics.dart';

import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/ui/widgets/icon_of.dart';
import 'package:guardian_keyper/data/services/platform_service.dart';

class QRCodeShowScreen extends StatefulWidget {
  const QRCodeShowScreen({super.key});

  @override
  State<QRCodeShowScreen> createState() => _QRCodeShowScreenState();
}

class _QRCodeShowScreenState extends State<QRCodeShowScreen> {
  final _platformService = GetIt.I<PlatformService>();

  late final arguments = ModalRoute.of(context)!.settings.arguments! as ({
    String qrCode,
    String caption,
    String subtitle,
  });

  @override
  void initState() {
    super.initState();
    _platformService.wakelockEnable();
  }

  @override
  void dispose() {
    _platformService.wakelockDisable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ScaffoldSafe(
        child: Column(
          children: [
            // Header
            HeaderBar(
              caption: arguments.caption,
              closeButton: const HeaderBarCloseButton(),
            ),
            // Body
            PageTitle(
              title: 'Your one-time Code',
              subtitle: arguments.subtitle,
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
                          data: arguments.qrCode,
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
                    _platformService.share(
                      'This is a SINGLE-USE authentication token'
                      ' for Guardian Keyper. DO NOT REUSE IT! \n '
                      '${arguments.qrCode}',
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
