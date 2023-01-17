import 'dart:math';
import 'dart:async';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

import '/src/core/theme/theme.dart';
import '/src/core/widgets/common.dart';
import '/src/core/widgets/icon_of.dart';
import '/src/core/model/core_model.dart';
import '/src/core/di_container.dart';

import '../guardian_controller.dart';

class QRCodePage extends StatefulWidget {
  final GroupId? groupId;

  const QRCodePage({super.key, this.groupId});

  @override
  State<QRCodePage> createState() => _QRCodePageState();
}

class _QRCodePageState extends State<QRCodePage> {
  static const _qrSize = 360.0;

  late final StreamSubscription<BoxEvent> _boxMessagesEventsSubscription;
  late final DIContainer _diContainer;
  late final String _qrCode;
  var _logoSize = 72.0;

  @override
  void initState() {
    super.initState();
    _diContainer = context.read<DIContainer>();
    _diContainer.networkService.startMdnsBroadcast();
    _diContainer.platformService.wakelockEnable();
    final qrCode =
        context.read<GuardianController>().generateQrCode(widget.groupId);
    _qrCode = qrCode.toBase64url();
    _boxMessagesEventsSubscription =
        _diContainer.boxMessages.watch(key: qrCode.aKey).listen(
      (event) {
        if (mounted && (event.value as MessageModel).isNotRequested) {
          Navigator.of(context).pop();
        }
      },
    );
  }

  @override
  void didChangeDependencies() {
    _logoSize = min(_qrSize, MediaQuery.of(context).size.width) / 5;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _diContainer.platformService.wakelockDisable();
    _boxMessagesEventsSubscription.cancel();
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
            'This is a one-time QR Code. Share it with the Owner of the Vault.',
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
                data: _qrCode,
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
                  ' DO NOT REUSE IT! \n $_qrCode',
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
