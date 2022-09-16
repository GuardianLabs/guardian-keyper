import '/src/core/theme_data.dart';
import '/src/core/widgets/misc.dart';
import '/src/core/widgets/common.dart';
import '/src/guardian/guardian_controller.dart';
import '/src/guardian/pages/show_qr_code_page.dart';

class MyQRCodeWidget extends StatelessWidget {
  const MyQRCodeWidget({super.key});

  @override
  Widget build(BuildContext context) => SelectableCard(
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
                          'Share your QR code to join a Recovery Group',
                          style: textStyleSourceSansPro414,
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
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ScaffoldWidget(
                        child: ShowQRCodePage(
                            qrCode: context
                                .read<GuardianController>()
                                .getQrCode())))),
              ),
            ),
          ],
        ),
      );
}
