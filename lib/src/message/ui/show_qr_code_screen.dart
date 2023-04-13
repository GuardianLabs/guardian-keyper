import 'package:get_it/get_it.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '/src/core/consts.dart';
import '/src/core/ui/widgets/common.dart';
import '/src/core/ui/widgets/icon_of.dart';
import '/src/core/data/platform_manager.dart';
import '/src/message/data/message_repository.dart';

class ShowQRCodeScreen extends StatefulWidget {
  static const routeName = routeShowQrCode;

  static MaterialPageRoute<void> getPageRoute(final RouteSettings settings) =>
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        settings: settings,
        builder: (context) {
          final message = settings.arguments as MessageModel;
          return ShowQRCodeScreen(key: Key(message.aKey), message: message);
        },
      );

  final MessageModel message;

  const ShowQRCodeScreen({super.key, required this.message});

  @override
  State<ShowQRCodeScreen> createState() => _ShowQRCodeScreenState();
}

class _ShowQRCodeScreenState extends State<ShowQRCodeScreen> {
  static const _caption = {
    MessageCode.createGroup: 'Become a Guardian',
    MessageCode.takeGroup: 'Change owner',
  };

  static const _subtitle = {
    MessageCode.createGroup:
        'This is a one-time for joining a Vault as a Guardian. '
            'You can either show it directly as a QR Code '
            'or Share as a Text via any messenger.',
    MessageCode.takeGroup:
        'This is a one-time for changing the owner of the Vault. '
            'You can either show it directly as a QR Code '
            'or Share as a Text via any messenger.',
  };

  final _platformManager = GetIt.I<PlatformManager>();

  late final _qrCode = widget.message.toBase64url();

  @override
  void initState() {
    super.initState();
    _platformManager.wakelockEnable();
  }

  @override
  void dispose() {
    _platformManager.wakelockDisable();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) => ScaffoldSafe(
        key: widget.key,
        child: Column(
          children: [
            // Header
            HeaderBar(
              caption: _caption[widget.message.code],
              closeButton: const HeaderBarCloseButton(),
            ),
            // Body
            PageTitle(
              title: 'Your one-time Code',
              subtitle: _subtitle[widget.message.code],
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
                      ),
                      LayoutBuilder(builder: (context, constraints) {
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
                          child: SvgPicture.asset(
                            'assets/icons/logo.svg',
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
                builder: (final BuildContext context) => ElevatedButton.icon(
                  icon: const IconOf.share(
                    bgColor: clIndigo500,
                    size: 20,
                  ),
                  label: const Text('Share Code'),
                  onPressed: () {
                    final box = context.findRenderObject() as RenderBox?;
                    _platformManager.share(
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
      );
}
