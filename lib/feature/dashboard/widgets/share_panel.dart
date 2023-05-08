import 'package:guardian_keyper/app/routes.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';

import '../dashboard_presenter.dart';

class SharePanel extends StatelessWidget {
  const SharePanel({super.key});

  @override
  Widget build(final BuildContext context) => Container(
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
                const Icon(
                  Icons.qr_code_2_rounded,
                  size: 60,
                  color: clWhite,
                ),
              ],
            ),
            Padding(
              padding: paddingTop20,
              child: ElevatedButton(
                child: const Text('Generate QR Code'),
                onPressed: () async {
                  final message = await context
                      .read<DashboardPresenter>()
                      .createJoinVaultCode();
                  if (context.mounted) {
                    Navigator.of(context).pushNamed(
                      routeQrCodeShow,
                      arguments: message,
                    );
                  }
                },
              ),
            ),
            Padding(
              padding: paddingTop20,
              child: OutlinedButton(
                onPressed: () async {
                  final box = context.findRenderObject() as RenderBox?;
                  await context.read<DashboardPresenter>().share(
                        'https://myguardian.network/app-router',
                        sharePositionOrigin:
                            box!.localToGlobal(Offset.zero) & box.size,
                      );
                },
                child: const Text('Share the App link'),
              ),
            ),
          ],
        ),
      );
}
