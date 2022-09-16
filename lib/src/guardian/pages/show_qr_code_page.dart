import 'dart:math';
import 'package:wakelock/wakelock.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

import '/src/core/theme_data.dart';
import '/src/core/widgets/common.dart';
import '/src/core/widgets/icon_of.dart';
import '/src/core/model/core_model.dart';

class ShowQRCodePage extends StatefulWidget {
  final QRCode qrCode;

  const ShowQRCodePage({super.key, required this.qrCode});

  @override
  State<ShowQRCodePage> createState() => _ShowQRCodePageState();
}

class _ShowQRCodePageState extends State<ShowQRCodePage> {
  static const _qrSize = 360.0;
  var _logoSize = 72.0;

  @override
  void initState() {
    super.initState();
    Wakelock.enable();
  }

  @override
  void didChangeDependencies() {
    _logoSize = min(_qrSize, MediaQuery.of(context).size.width) / 5;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    Wakelock.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(children: [
        // Header
        const HeaderBar(
          caption: 'My QR Code',
          closeButton: HeaderBarCloseButton(),
        ),
        // Body
        Padding(
          padding: paddingAll20,
          child: Text(
            'This is a one-time QR Code.'
            ' Show it to the Owner of the Recovery Group.',
            textAlign: TextAlign.center,
            style: textStyleSourceSansPro416,
          ),
        ),
        // QR Code
        Padding(
          padding: paddingH20,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: _qrSize,
                maxWidth: _qrSize,
              ),
              child: QrImageView(
                gapless: false,
                padding: paddingAll20,
                backgroundColor: clSurface,
                foregroundColor: Colors.white,
                embeddedImageStyle: QrEmbeddedImageStyle(
                  size: Size.square(_logoSize),
                ),
                embeddedImage: const AssetImage(
                  'assets/images/logo_qr.png',
                ),
                dataModuleStyle: const QrDataModuleStyle(
                  color: clPurpleLight,
                  dataModuleShape: QrDataModuleShape.circle,
                ),
                eyeStyle: const QrEyeStyle(eyeShape: QrEyeShape.circle),
                errorCorrectionLevel: QrErrorCorrectLevel.M,
                data: widget.qrCode.toBase64url(),
              ),
              // ),
            ),
          ),
        ),
        // Share Button
        Container(
          padding: paddingAll20,
          width: _qrSize + 40, // padding 20+20
          child: Builder(
            builder: (BuildContext context) => ElevatedButton.icon(
              icon: const IconOf.share(bgColor: clIndigo500, size: 20),
              label: const Text('Share Code'),
              onPressed: () async {
                final box = context.findRenderObject() as RenderBox?;
                await Share.share(
                  'This is a SINGLE-USE authentication token for Guardian Keyper.'
                  ' DO NOT REUSE IT! \n ${widget.qrCode.toBase64url()}',
                  subject: 'Guardian Code',
                  sharePositionOrigin:
                      box!.localToGlobal(Offset.zero) & box.size,
                );
                if (mounted) Navigator.of(context).pop();
              },
            ),
          ),
        ),
      ]);
}
