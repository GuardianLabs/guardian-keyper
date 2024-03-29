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
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          const HeaderBar(
            caption: 'Restore my Safe',
            rightButton: HeaderBarButton.close(),
          ),
          // Body
          const PageTitle(
            title: 'Add a Guardian to proceed with a Safe recovery',
            subtitle: 'Ask a Guardian to tap on “Assist with Safe” in the app, '
                'select the Safe you need, and provide their '
                'Assistance QR code or text code.',
          ),
          // Scan QR
          Padding(
            padding: paddingH20,
            child: FilledButton(
              onPressed: () => OnQrCodeScanDialog.show(
                context,
                caption: 'Scan the Assistance QR',
              ).then(
                (value) => _setCode(context, value),
              ),
              child: const Text('Add with a QR Code'),
            ),
          ),
          // Input QR
          Padding(
            padding: paddingAll20,
            child: OutlinedButton(
              onPressed: () => OnCodeInputDialog.show(context).then(
                (value) => _setCode(context, value),
              ),
              child: const Text('Add with a Text Code'),
            ),
          ),
        ],
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
