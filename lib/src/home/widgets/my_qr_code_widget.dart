import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../pages/show_qr_code_page.dart';
import '/src/core/theme_data.dart';
import '/src/core/widgets/selectable_card.dart';

class MyQRCodeWidget extends StatelessWidget {
  const MyQRCodeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SelectableCard(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My QR Code',
                  textAlign: TextAlign.left,
                  style: textStylePoppinsBold16,
                ),
                const SizedBox(height: 16),
                RichText(
                  textAlign: TextAlign.left,
                  softWrap: true,
                  overflow: TextOverflow.clip,
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Share your QR code with \nother Guardians.',
                        style: textStyleSourceSansProRegular14,
                      ),
                      TextSpan(
                        text: ' Learn more',
                        style: textStyleSourceSansProBold14Blue,
                      ),
                    ],
                  ),
                ),
                Text(
                  '',
                  style: textStyleSourceSansProBold14,
                ),
              ],
            ),
            SizedBox(
              height: 80,
              width: 80,
              child: QrImage(foregroundColor: Colors.white, data: ''),
            ),
          ],
        ),
        Row(
          children: [
            const Expanded(
              child: ElevatedButton(
                child: Text('Share QR'),
                onPressed: null,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                child: const Text('Show QR'),
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: ((_) => const ShowQRCodePage()))),
              ),
            ),
          ],
        ),
      ],
    ));
  }
}
