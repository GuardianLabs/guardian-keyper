import 'package:get_it/get_it.dart';

import 'package:guardian_keyper/ui/widgets/emoji.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/ui/widgets/icon_of.dart';
import 'package:guardian_keyper/ui/dialogs/qr_code_show_dialog.dart';

import 'package:guardian_keyper/feature/vault/domain/entity/vault_id.dart';
import 'package:guardian_keyper/feature/message/domain/use_case/message_interactor.dart';

class OnChangeOwnerDialog extends StatelessWidget {
  static Future<void> show(
    BuildContext context, {
    required VaultId vaultId,
  }) =>
      showModalBottomSheet(
        context: context,
        isDismissible: false,
        isScrollControlled: true,
        builder: (_) => OnChangeOwnerDialog(vaultId: vaultId),
      );

  const OnChangeOwnerDialog({
    required this.vaultId,
    super.key,
  });

  final VaultId vaultId;

  @override
  Widget build(BuildContext context) => BottomSheetWidget(
        icon: const IconOf.owner(
          isBig: true,
          bage: BageType.warning,
        ),
        titleString: 'Change Owner',
        textSpan: buildTextWithId(
          leadingText: 'Are you sure you want to change owner for vault ',
          id: vaultId,
          trailingText: '? This action cannot be undone.',
        ),
        footer: Column(
          children: [
            PrimaryButton(
              text: 'Confirm',
              onPressed: () async {
                Navigator.of(context).pop();
                final message = await GetIt.I<MessageInteractor>()
                    .createTakeVaultCode(vaultId);
                if (context.mounted) {
                  QRCodeShowDialog.showAsReplacement(
                    context,
                    qrCode: message.toBase64url(),
                    caption: 'Change owner',
                    subtitle:
                        // ignore: lines_longer_than_80_chars
                        'This is a one-time for changing the owner of the Vault. '
                        'You can either show it directly as a QR Code '
                        'or Share as a Text via any messenger.',
                  );
                }
              },
            ),
            const Padding(padding: paddingT20),
            SizedBox(
              width: double.infinity,
              child: TertiaryButton(
                text: 'Keep current Owner',
                onPressed: Navigator.of(context).pop,
              ),
            ),
          ],
        ),
      );
}
