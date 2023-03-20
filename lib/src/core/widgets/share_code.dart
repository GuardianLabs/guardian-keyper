import 'package:qr_flutter/qr_flutter.dart';

import '/src/core/widgets/common.dart';
import '/src/core/widgets/icon_of.dart';

typedef ShowShareDialog = Future<void> Function(
  String text, {
  String? subject,
  Rect? sharePositionOrigin,
});

class ShareCode extends StatelessWidget {
  final Widget pageTitle;
  final String caption, code;
  final ShowShareDialog showShareDialog;

  const ShareCode({
    super.key,
    required this.code,
    required this.caption,
    required this.pageTitle,
    required this.showShareDialog,
  });

  @override
  Widget build(final BuildContext context) => ScaffoldWidget(
        child: Column(
          children: [
            // Header
            HeaderBar(
              caption: caption,
              closeButton: const HeaderBarCloseButton(),
            ),
            // Body
            pageTitle,
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
                          data: code,
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
                          label: const Text('Share Text Code'),
                          onPressed: () async {
                            final box =
                                context.findRenderObject() as RenderBox?;
                            await showShareDialog(
                              'This is a SINGLE-USE code for Guardian Keyper.'
                              ' DO NOT REUSE IT! \n $code',
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
            ),
          ],
        ),
      );
}
