import 'dart:async';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

import '/src/core/widgets/common.dart';
import '/src/core/widgets/icon_of.dart';
import '/src/core/repository/repository.dart';
import '/src/core/service/platform_service.dart';

import '/src/guardian/guardian_controller.dart';
import '/src/guardian/widgets/message_list_tile.dart';

class QRCodePage extends StatefulWidget {
  final GroupId? groupId;

  const QRCodePage({super.key, this.groupId});

  @override
  State<QRCodePage> createState() => _QRCodePageState();
}

class _QRCodePageState extends State<QRCodePage> {
  late final StreamSubscription<BoxEvent> _boxMessagesEventsSubscription;
  late final String _qrCode;

  @override
  void initState() {
    super.initState();
    GetIt.I<PlatformService>().wakelockEnable();
    final qrCode = _generateQrCode();
    _qrCode = qrCode.toBase64url();
    _boxMessagesEventsSubscription =
        GetIt.I<Box<MessageModel>>().watch(key: qrCode.aKey).listen(
      (event) async {
        if (!mounted) return;
        final message = event.value as MessageModel;
        if (message.isReceived) {
          _boxMessagesEventsSubscription.cancel();
          await MessageListTile.showActiveMessage(context, message);
          if (mounted) Navigator.of(context).pop();
        }
      },
    );
  }

  @override
  void dispose() {
    GetIt.I<PlatformService>().wakelockDisable();
    _boxMessagesEventsSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) => ScaffoldWidget(
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
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        QrImageView(
                          gapless: false,
                          padding: paddingAll20,
                          foregroundColor: Colors.white,
                          dataModuleStyle: const QrDataModuleStyle(
                            color: clPurpleLight,
                            dataModuleShape: QrDataModuleShape.circle,
                          ),
                          eyeStyle: const QrEyeStyle(
                            eyeShape: QrEyeShape.circle,
                          ),
                          errorCorrectionLevel: QrErrorCorrectLevel.M,
                          data: _qrCode,
                        ),
                        Container(
                          constraints: const BoxConstraints(
                            minWidth: 90,
                            maxWidth: 120,
                            minHeight: 90,
                            maxHeight: 120,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            color: clSurface,
                          ),
                          padding: paddingAll8,
                          child: const IconOf.app(),
                        ),
                      ],
                    ),
                    // Share Button
                    Container(
                      padding: paddingAll20,
                      width: double.infinity,
                      child: Builder(
                        builder: (final BuildContext context) =>
                            ElevatedButton.icon(
                          icon: const IconOf.share(
                            bgColor: clIndigo500,
                            size: 20,
                          ),
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
    final isNew = widget.groupId == null;
    final message = MessageModel(
      code: isNew ? MessageCode.createGroup : MessageCode.takeGroup,
      peerId: GetIt.I<GuardianController>().state,
    );
    GetIt.I<Box<MessageModel>>().put(
      message.aKey,
      isNew
          ? message
          // save groupId for transaction
          : message.copyWith(payload: RecoveryGroupModel(id: widget.groupId)),
    );
    return message;
  }
}
