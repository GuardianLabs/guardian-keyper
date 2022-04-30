import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../theme_data.dart';
import '../widgets/common.dart';
import '../widgets/icon_of.dart';

class QRCodePage extends StatelessWidget {
  final String qrCode;
  final Widget? child;

  const QRCodePage({
    Key? key,
    required this.qrCode,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final size = height >= heightMedium
        ? height / 3
        : height >= heightSmall
            ? height / 2
            : height / 3;
    return Column(
      children: [
        // Header
        const HeaderBar(
          title: HeaderBarTitleLogo(),
          closeButton: HeaderBarCloseButton(),
        ),
        // Body
        PaddingTop(
          child: Container(
            alignment: Alignment.center,
            height: size,
            width: size,
            child: QrImage(foregroundColor: Colors.white, data: qrCode),
          ),
        ),
        if (child != null) PaddingTop(child: child!),
        Expanded(child: Container()),
        Padding(
          padding: paddingBottom20,
          child: ElevatedButton.icon(
            icon: const IconOf.share(bgColor: clIndigo500, size: 16),
            style: buttonStyleSecondary,
            label: const Text('Share My QR Code'),
            onPressed: () {},
          ),
        ),
        Padding(
          padding: paddingBottom20,
          child: TextButton(
            child: Text(
              'Download QR Code',
              style: textStylePoppinsBold16Blue,
            ),
            onPressed: null,
          ),
        ),
      ],
    );
  }
}
