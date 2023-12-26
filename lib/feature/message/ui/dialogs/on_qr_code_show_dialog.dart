import 'dart:async';

import 'package:qr_flutter/qr_flutter.dart';

import 'package:guardian_keyper/consts.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/data/services/platform_service.dart';

import 'package:guardian_keyper/feature/message/data/message_repository.dart';
import 'package:guardian_keyper/feature/message/domain/entity/message_model.dart';
import 'package:guardian_keyper/feature/message/ui/dialogs/on_message_active_dialog.dart';

class OnQRCodeShowDialog extends StatefulWidget {
  static const route = '/qrcode/show';

  static Future<void> show(
    BuildContext context, {
    required String caption,
    required String title,
    required String subtitle,
    required MessageModel message,
  }) =>
      Navigator.of(context).push(MaterialPageRoute(
        fullscreenDialog: true,
        settings: const RouteSettings(name: route),
        builder: (_) => OnQRCodeShowDialog(
          caption: caption,
          title: title,
          subtitle: subtitle,
          message: message,
        ),
      ));

  const OnQRCodeShowDialog({
    required this.caption,
    required this.title,
    required this.subtitle,
    required this.message,
    super.key,
  });

  final String caption;
  final String title;
  final String subtitle;
  final MessageModel message;

  @override
  State<OnQRCodeShowDialog> createState() => _OnQRCodeShowDialogState();
}

class _OnQRCodeShowDialogState extends State<OnQRCodeShowDialog> {
  late final StreamSubscription<MessageRepositoryEvent> _requestsStream;

  late final String _qrCode = widget.message.toBase64url();

  bool _canShowNotification = true;

  @override
  void initState() {
    super.initState();
    GetIt.I<PlatformService>().wakelockEnable();
    _requestsStream =
        GetIt.I<MessageRepository>().watch(widget.message.aKey).listen(
      (e) {
        if (_canShowNotification && e.message!.isReceived) {
          _canShowNotification = false;
          OnMessageActiveDialog.show(
            context,
            message: e.message!,
          ).then((_) {
            if (mounted) Navigator.of(context).pop();
          });
        }
      },
    );
  }

  @override
  void dispose() {
    GetIt.I<PlatformService>().wakelockDisable();
    _requestsStream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ScaffoldSafe(
      header: HeaderBar(
        caption: widget.caption,
        leftButton: const HeaderBarButton.back(),
        rightButton: HeaderBarButton.close(
          onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst),
        ),
      ),
      children: [
        // Text
        PageTitle(
          title: widget.title,
          subtitle: widget.subtitle,
        ),
        // QR Code
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(12),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.width / 2,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: colorScheme.surface,
          ),
          child: QrImageView(
            data: _qrCode,
            errorCorrectionLevel: QrErrorCorrectLevel.M,
            dataModuleStyle: QrDataModuleStyle(
              color: colorScheme.onSurface,
              dataModuleShape: QrDataModuleShape.square,
            ),
            eyeStyle: QrEyeStyle(
              color: colorScheme.onSurface,
              eyeShape: QrEyeShape.square,
            ),
          ),
        ),
        const Padding(
          padding: paddingV20,
          child: Text(
            'Text Code',
            textAlign: TextAlign.center,
          ),
        ),
        // Share Button
        Padding(
          padding: paddingB20,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  decoration: ShapeDecoration(
                    color: colorScheme.surface,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: colorScheme.secondary),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        bottomLeft: Radius.circular(8),
                      ),
                    ),
                  ),
                  height: buttonSize,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      _qrCode,
                      style: Theme.of(context).textTheme.bodySmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
              Container(
                decoration: ShapeDecoration(
                  color: colorScheme.primary,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                  ),
                ),
                height: buttonSize,
                child: Builder(
                  builder: (context) => IconButton(
                    icon: Transform.flip(
                      flipX: true,
                      child: const Icon(Icons.reply),
                    ),
                    onPressed: () {
                      final box = context.findRenderObject() as RenderBox?;
                      GetIt.I<PlatformService>().share(
                        'This is a SINGLE-USE authentication token for '
                        'Guardian Keyper. DO NOT REUSE IT! \n $_qrCode',
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
    );
  }
}
