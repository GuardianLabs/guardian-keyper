import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/ui/dialogs/qr_code_scan_dialog.dart';
import 'package:guardian_keyper/feature/vault/ui/dialogs/on_version_low.dart';
import 'package:guardian_keyper/feature/vault/ui/dialogs/on_version_high.dart';
import 'package:guardian_keyper/feature/vault/ui/dialogs/on_invalid_dialog.dart';
import 'package:guardian_keyper/feature/vault/ui/dialogs/on_code_input_dialog.dart';

import '../vault_restore_presenter.dart';
import '../dialogs/on_duplicate_dialog.dart';
import '../dialogs/on_fail_dialog.dart';

class GetCodePage extends StatelessWidget {
  const GetCodePage({super.key});

  @override
  Widget build(BuildContext context) {
    final presenter = context.read<VaultRestorePresenter>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header
        const HeaderBar(
          caption: 'Restore my Vault',
          closeButton: HeaderBarCloseButton(),
        ),
        // Body
        const PageTitle(
          title: 'Add a Guardian to start a Vault recovery',
          subtitle: 'Ask a Guardian to tap “Assist with Vault” in the app, '
              'select the Vault you need, and provide their '
              'Assistance QR code or text code.',
        ),
        // Scan QR
        Padding(
          padding: paddingH20,
          child: FilledButton(
            onPressed: () async {
              final code = await QRCodeScanDialog.show(
                context,
                caption: 'Scan the Assistance QR',
              );
              if (context.mounted) _setCode(context, presenter, code);
            },
            child: const Text('Add via a QR Code'),
          ),
        ),
        // Input QR
        Padding(
          padding: paddingAll20,
          child: OutlinedButton(
            onPressed: () async {
              final code = await OnCodeInputDialog.show(context);
              if (context.mounted) _setCode(context, presenter, code);
            },
            child: const Text('Add via a Text Code'),
          ),
        ),
      ],
    );
  }

  void _setCode(
    BuildContext context,
    VaultRestorePresenter presenter,
    String? code,
  ) {
    try {
      presenter.setCode(code);
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
