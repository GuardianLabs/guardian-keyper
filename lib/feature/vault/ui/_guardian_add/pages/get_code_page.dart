import 'package:guardian_keyper/ui/utils/utils.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/ui/dialogs/qr_code_scan_dialog.dart';
import 'package:guardian_keyper/feature/vault/ui/dialogs/on_version_low.dart';
import 'package:guardian_keyper/feature/vault/ui/dialogs/on_version_high.dart';
import 'package:guardian_keyper/feature/vault/ui/dialogs/on_invalid_dialog.dart';
import 'package:guardian_keyper/feature/vault/ui/dialogs/on_code_input_dialog.dart';

import '../vault_guardian_add_presenter.dart';
import '../dialogs/on_duplicate_dialog.dart';
import '../dialogs/on_fail_dialog.dart';

class GetCodePage extends StatelessWidget {
  const GetCodePage({super.key});

  @override
  Widget build(BuildContext context) {
    final presenter = context.read<VaultGuardianAddPresenter>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header
        HeaderBar(
          captionSpans: buildTextWithId(name: presenter.vaultId.name),
          closeButton: const HeaderBarCloseButton(),
        ),
        // Body
        PageTitle(
          title: 'Add your Guardians',
          subtitleSpans: [
            TextSpan(
              style: styleSourceSansPro616Purple,
              text: 'Add Guardian(s) ',
            ),
            TextSpan(
              style: styleSourceSansPro416Purple,
              text: 'to enable your Vault and secure your Secrets.',
            ),
          ],
        ),
        // Scan QR
        Padding(
          padding: paddingH20,
          child: FilledButton(
            onPressed: () async {
              final code = await QRCodeScanDialog.show(
                context,
                caption: 'Scan the Guardian QR',
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
    VaultGuardianAddPresenter presenter,
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
    } on SetCodeDuplicateException catch (e) {
      OnDuplicateDialog.show(context, peerId: e.message.peerId);
    }
  }
}
