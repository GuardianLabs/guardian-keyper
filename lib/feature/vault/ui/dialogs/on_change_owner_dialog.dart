import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/ui/widgets/icon_of.dart';

import 'package:guardian_keyper/feature/vault/domain/entity/vault_id.dart';
import 'package:guardian_keyper/feature/message/domain/use_case/message_interactor.dart';
import 'package:guardian_keyper/feature/message/ui/dialogs/on_qr_code_show_dialog.dart';

class OnChangeOwnerDialog extends StatelessWidget {
  static Future<void> show(
    BuildContext context, {
    required VaultId vaultId,
  }) =>
      showModalBottomSheet(
        context: context,
        isDismissible: true,
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
        icon: const IconOf.confirmIdentity(size: 80),
        titleString: 'Confirm Identity!',
        textString: 'Helping with Safe recovery or changing ownership?\n'
            'Please verify if the person is the current '
            'Owner or a newly approved one.\n\n'
            'Assisting a malicious individual could result in asset loss!',
        footer: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FilledButton(
              child: const Text('Confirm'),
              onPressed: () async {
                final message = await GetIt.I<MessageInteractor>()
                    .createTakeVaultCode(vaultId);
                if (context.mounted) {
                  Navigator.of(context).pop();
                  OnQRCodeShowDialog.show(
                    context,
                    message: message,
                    caption: vaultId.name,
                    title: 'Assistance QR',
                    subtitle:
                        'Only display this Assistance QR to the current or '
                        'a new designated Safe Owner. If sharing QR is not '
                        'possible, try sharing a text-code instead.',
                  );
                }
              },
            ),
            const Padding(padding: paddingT20),
            FilledButton(
              onPressed: Navigator.of(context).pop,
              child: const Text('Cancel'),
            ),
          ],
        ),
      );
}
