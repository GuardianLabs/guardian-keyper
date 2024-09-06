import 'package:guardian_keyper/ui/widgets/common.dart';

import 'package:guardian_keyper/feature/vault/ui/dialogs/on_version_low.dart';
import 'package:guardian_keyper/feature/vault/ui/dialogs/on_version_high.dart';
import 'package:guardian_keyper/feature/vault/ui/dialogs/on_invalid_dialog.dart';
import 'package:guardian_keyper/feature/vault/ui/dialogs/on_qr_code_scan_dialog.dart';
import 'package:guardian_keyper/feature/vault/ui/dialogs/on_code_input_dialog.dart';
import 'package:guardian_keyper/feature/vault/ui/_secret_add/dialogs/on_fail_dialog.dart';
import 'package:guardian_keyper/feature/vault/ui/_guardian_add/dialogs/on_duplicate_dialog.dart';

import '../vault_guardian_add_presenter.dart';

class GetCodePage extends StatelessWidget {
  const GetCodePage({super.key});

  @override
  Widget build(BuildContext context) => ScaffoldSafe(
        appBar: AppBar(
          title: const Text('Add a Guardian'),
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
              subtitle: 'Ask a Guardian to open the Shards tab in the app, '
                  'tap the “Become a Guardian” button, and provide '
                  'their Guardian QR code or text code.',
            ),
            // Scan QR
            Padding(
              padding: paddingHDefault,
              child: FilledButton(
                onPressed: () async {
                  final code = await OnQrCodeScanDialog.show(
                    context,
                    caption: 'Scan the Guardian QR',
                  );
                  if (context.mounted) _setCode(context, code);
                },
                child: const Text('Add via QR code'),
              ),
            ),
            // Input QR
            Padding(
              padding: paddingAllDefault,
              child: OutlinedButton(
                onPressed: () async {
                  final code = await OnCodeInputDialog.show(context);
                  if (context.mounted) _setCode(context, code);
                },
                child: Text(
                  'Add via Text code',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onSecondary),
                ),
              ),
            ),
          ],
        ),
      );

  void _setCode(BuildContext context, String? code) {
    try {
      context.read<VaultGuardianAddPresenter>().setCode(code);
    } on SetCodeEmptyException {
      OnInvalidDialog.show(context);
    } on SetCodeFailException {
      OnFailDialog.show(context);
    } on SetCodeVersionLowException {
      OnVersionLowDialog.show(context);
    } on SetCodeVersionHighException {
      OnVersionHighDialog.show(context);
    } on SetCodeDuplicateException catch (e) {
      OnDuplicateDialog.show(
        context,
        peerName: e.message.peerId.name,
      );
    }
  }
}
