import 'dart:async';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

import '/src/core/theme/theme.dart';
import '/src/core/widgets/common.dart';
import '/src/core/widgets/icon_of.dart';
import '/src/core/model/core_model.dart';
import '/src/core/di_container.dart';

class QRCodePage extends StatefulWidget {
  final GroupId? groupId;

  const QRCodePage({super.key, this.groupId});

  @override
  State<QRCodePage> createState() => _QRCodePageState();
}

class _QRCodePageState extends State<QRCodePage> {
  late final StreamSubscription<BoxEvent> _boxMessagesEventsSubscription;
  late final DIContainer _diContainer;
  late final String _qrCode;

  @override
  void initState() {
    super.initState();
    _diContainer = context.read<DIContainer>();
    _diContainer.platformService.wakelockEnable();
    final qrCode = _generateQrCode();
    _qrCode = qrCode.toBase64url();
    _boxMessagesEventsSubscription =
        _diContainer.boxMessages.watch(key: qrCode.aKey).listen((event) {
      if (mounted && (event.value as MessageModel).isNotRequested) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  void dispose() {
    _diContainer.platformService.wakelockDisable();
    _boxMessagesEventsSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ScaffoldWidget(
        child: Column(
          children: [
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
            Padding(
              padding: paddingH20,
              child: Container(
                decoration: boxDecoration,
                constraints: const BoxConstraints(minWidth: 300, maxWidth: 400),
                child: Column(
                  children: [
                    // QR Code
                    QrImageView(
                      gapless: false,
                      padding: paddingAll20,
                      foregroundColor: Colors.white,
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
                    // Share Button
                    Container(
                      padding: paddingAll20,
                      width: double.infinity,
                      child: Builder(
                        builder: (BuildContext context) => ElevatedButton.icon(
                          icon: const IconOf.share(
                              bgColor: clIndigo500, size: 20),
                          label: const Text('Share Code'),
                          onPressed: () async {
                            final box =
                                context.findRenderObject() as RenderBox?;
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
                  ],
                ),
              ),
            ),
          ],
        ),
      );

  /// Create ticket to create\take group
  MessageModel _generateQrCode() {
    final message = widget.groupId == null
        ? MessageModel(code: MessageCode.createGroup)
        : MessageModel(
            code: MessageCode.takeGroup,
            payload: RecoveryGroupModel(id: widget.groupId),
          );
    // save groupId for transaction
    _diContainer.boxMessages.put(message.aKey, message);
    return message.copyWith(
      peerId: _diContainer.myPeerId,
      payload: PeerAddressList(
        addresses: _diContainer.networkService.myAddresses,
      ),
    );
  }
}
