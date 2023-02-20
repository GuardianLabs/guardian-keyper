import '/src/core/theme/theme.dart';
import '/src/core/widgets/common.dart';

import '../pages/qr_code_page.dart';

class QRCodePanel extends StatelessWidget {
  const QRCodePanel({super.key});

  @override
  Widget build(BuildContext context) => Container(
        decoration: boxDecoration,
        padding: paddingAll20,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Become a Guardian', style: textStylePoppins616),
                      Padding(
                        padding: paddingTop12,
                        child: Text(
                          'Share your QR code to join a Vault',
                          style: textStyleSourceSansPro416Purple,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                const Icon(Icons.qr_code_2_rounded, size: 60, color: clWhite),
              ],
            ),
            Padding(
              padding: paddingTop20,
              child: ElevatedButton(
                child: const Text('Generate QR Code'),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    fullscreenDialog: true,
                    maintainState: false,
                    builder: (_) => const QRCodePage(),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}
