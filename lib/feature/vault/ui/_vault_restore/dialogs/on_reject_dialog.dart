import 'package:guardian_keyper/ui/widgets/emoji.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/ui/widgets/icon_of.dart';
import 'package:guardian_keyper/domain/entity/message_model.dart';

class OnRejectDialog extends StatelessWidget {
  static Future<void> show(
    final BuildContext context,
    final MessageModel message,
  ) =>
      showModalBottomSheet(
        context: context,
        isDismissible: false,
        isScrollControlled: true,
        builder: (final BuildContext context) =>
            OnRejectDialog(message: message),
      );

  const OnRejectDialog({super.key, required this.message});

  final MessageModel message;

  @override
  Widget build(final BuildContext context) => BottomSheetWidget(
        icon: const IconOf.secrets(isBig: true, bage: BageType.error),
        titleString: 'Ownership Transfer Rejected',
        textSpan: [
          ...buildTextWithId(
            id: message.peerId,
            trailingText: ' rejected the transfer of ownership for the Vault ',
          ),
          ...buildTextWithId(id: message.vaultId),
        ],
        body: Padding(
          padding: paddingV20,
          child: Container(
            decoration: boxDecoration,
            padding: paddingAll20,
            child: Text(
              'Since Guardian rejected ownership transfer, '
              'it is impossible to restore the Vault.',
              style: textStyleSourceSansPro416Purple,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        footer: PrimaryButton(
          text: 'Close',
          onPressed: Navigator.of(context).pop,
        ),
      );
}
