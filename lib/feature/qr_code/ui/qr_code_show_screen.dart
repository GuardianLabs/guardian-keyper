import 'package:get_it/get_it.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vector_graphics/vector_graphics.dart';

import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/ui/widgets/icon_of.dart';
import 'package:guardian_keyper/data/platform_service.dart';
import 'package:guardian_keyper/feature/message/domain/entity/message_model.dart';

class QRCodeShowScreen extends StatefulWidget {
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

  const QRCodeShowScreen({super.key});

  @override
  State<QRCodeShowScreen> createState() => _QRCodeShowScreenState();
}

class _QRCodeShowScreenState extends State<QRCodeShowScreen> {
  final _platformService = GetIt.I<PlatformService>();

  // TBD: Get needed params via constructor, remove MessageModel dependency
  late final _message =
      ModalRoute.of(context)!.settings.arguments as MessageModel;
  late final _qrCode = _message.toBase64url();

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
              caption: QRCodeShowScreen._caption[_message.code],
              closeButton: const HeaderBarCloseButton(),
            ),
            // Body
            PageTitle(
              title: 'Your one-time Code',
              subtitle: QRCodeShowScreen._subtitle[_message.code],
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
                          data: _qrCode,
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
