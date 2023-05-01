import 'package:guardian_keyper/src/core/ui/widgets/emoji.dart';
import 'package:guardian_keyper/src/core/ui/widgets/common.dart';
import 'package:guardian_keyper/src/core/ui/widgets/icon_of.dart';
import 'package:guardian_keyper/src/core/domain/entity/core_model.dart';

class OnSuccessDialog extends StatelessWidget {
  static Future<void> show(
    final BuildContext context,
    final MessageModel message,
  ) =>
      showModalBottomSheet(
        context: context,
        isDismissible: false,
        isScrollControlled: true,
        builder: (final BuildContext context) =>
            OnSuccessDialog(message: message),
      );

  const OnSuccessDialog({super.key, required this.message});

  final MessageModel message;

  @override
  Widget build(final BuildContext context) => message.vault.isFull
      ? BottomSheetWidget(
          icon: const IconOf.secrets(isBig: true, bage: BageType.ok),
          titleString: 'Ownership Changed',
          textSpan: buildTextWithId(
            leadingText: 'The ownership of the Vault ',
            id: message.vaultId,
            trailingText: ' has been transferred to your device.',
          ),
          footer: PrimaryButton(
            text: 'Done',
            onPressed: Navigator.of(context).pop,
          ),
        )
      : BottomSheetWidget(
          icon: const IconOf.secrets(isBig: true, bage: BageType.ok),
          titleString: 'Ownership Transfer Approved',
          textSpan: [
            ...buildTextWithId(
              id: message.peerId,
              trailingText:
                  ' approved the transfer of ownership for the Vault ',
            ),
            ...buildTextWithId(id: message.vaultId),
          ],
          footer: PrimaryButton(
            text: 'Add another Guardian',
            onPressed: Navigator.of(context).pop,
          ),
        );
}
