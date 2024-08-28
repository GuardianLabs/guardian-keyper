import 'package:guardian_keyper/ui/widgets/common.dart';

import 'package:guardian_keyper/feature/vault/ui/dialogs/on_version_low.dart';
import 'package:guardian_keyper/feature/vault/ui/dialogs/on_version_high.dart';
import 'package:guardian_keyper/feature/vault/ui/dialogs/on_invalid_dialog.dart';
import 'package:guardian_keyper/feature/vault/ui/dialogs/on_qr_code_scan_dialog.dart';
import 'package:guardian_keyper/feature/vault/ui/dialogs/on_code_input_dialog.dart';

import '../vault_restore_presenter.dart';
import '../dialogs/on_duplicate_dialog.dart';
import '../dialogs/on_fail_dialog.dart';

class GetCodePage extends StatelessWidget {
  const GetCodePage({super.key});

  @override
  Widget build(BuildContext context) => ScaffoldSafe(
        appBar: AppBar(
          title: const Text('Restore your Safe'),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Body
            const PageTitle(
              subtitle: 'This screen will help you restore your safe created '
                  'on another device if you`ve lost access to it.'
                  '\n\nAsk a Guardian of the restoring safe to open the Shards tab '
                  'in the app, tap the “Help Restore a Safe” button, select the Safe '
                  'you need, and provide their Assistance QR code or text code.',
            ),
            // Scan QR
            Padding(
              padding: paddingH20,
              child: FilledButton(
                onPressed: () async {
                  final qrCode = await OnQrCodeScanDialog.show(
                    context,
                    caption: 'Scan the Assistance QR',
                  );
                  if (context.mounted) _setCode(context, qrCode);
                },
                child: const Text('Restore via QR code'),
              ),
            ),
            // Input QR
            Padding(
              padding: paddingAll20,
              child: OutlinedButton(
                onPressed: () async {
                  final qrCode = await OnCodeInputDialog.show(context);
                  if (context.mounted) _setCode(context, qrCode);
                },
                child: const Text('Restore via Text code'),
              ),
            ),
          ],
        ),
      );

  void _setCode(BuildContext context, String? code) {
    if (!context.mounted) return;
    try {
      context.read<VaultRestorePresenter>().setCode(code);
    } on SetCodeEmptyException {
      OnInvalidDialog.show(context);
    } on SetCodeFailException {
      OnFailDialog.show(context);
    } on SetCodeVersionLowException {
      OnVersionLowDialog.show(context);
    } on SetCodeVersionHighException {
      OnVersionHighDialog.show(context);
    } on SetCodeDuplicateException {
      OnDuplicateDialog.show(context);
    }
  }
}
