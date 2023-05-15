import 'package:guardian_keyper/ui/widgets/emoji.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/ui/widgets/icon_of.dart';
import 'package:guardian_keyper/feature/message/domain/entity/message_model.dart';

class OnDuplicateDialog extends StatelessWidget {
  static Future<void> show(
    BuildContext context, {
    required MessageModel message,
  }) =>
      showModalBottomSheet(
        context: context,
        isDismissible: false,
        isScrollControlled: true,
        builder: (_) => OnDuplicateDialog(message: message),
      );

  const OnDuplicateDialog({
    super.key,
    required this.message,
  });

  final MessageModel message;

  @override
  Widget build(BuildContext context) => BottomSheetWidget(
        titleString: 'You can’t add the same Guardian twice',
        textSpan: [
          const TextSpan(text: 'Seems like you’ve already added '),
          ...buildTextWithId(id: message.peerId),
          const TextSpan(
            text: ' to this Vault. Try adding a different Guardian.',
          ),
        ],
        icon: const IconOf.shield(isBig: true, bage: BageType.error),
        footer: PrimaryButton(
          text: 'Close',
          onPressed: Navigator.of(context).pop,
        ),
      );
}
